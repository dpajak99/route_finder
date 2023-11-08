import 'dart:convert';

import 'package:latlong2/latlong.dart' as map;
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/dto/google_api/response/get_directions_response.dart';
import 'package:path_finder/infra/dto/google_api/response/route_dto.dart';
import 'package:path_finder/infra/entity/stop_entity.dart';
import 'package:path_finder/infra/entity/transit_edge_entity.dart';
import 'package:path_finder/infra/entity/vehicle_edge_entity.dart';
import 'package:path_finder/infra/entity/walk_edge_entity.dart';
import 'package:path_finder/infra/postgres_database.dart';
import 'package:path_finder/infra/repository/edge_repository.dart';
import 'package:path_finder/infra/repository/google_repository.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/file_utils.dart';
import 'package:path_finder/utils/google_coords_utils.dart';
import 'package:path_finder/utils/models/distance.dart';
import 'package:postgres/postgres.dart';

class PostgresEdgeRepository extends EdgeRepository {
  static const double maxWalkingDistanceInMeters = 1500;

  final PostgreSQLConnection sql = postgresDatabase.postgreSQLConnection;
  final StopRepository stopRepository = getIt<StopRepository>();
  final GoogleRepository googleRepository = getIt<GoogleRepository>();

  @override
  Future<List<TransitEdgeEntity>> getAll() async {
    List<StopEntity> stops = await stopRepository.getAll();
    List<Map<String, Map<String, dynamic>>> result = await sql.mappedResultsQuery(
      'select bl.name as "name", d.time_in_min as "departure_time_in_min", d.time_to_next_stop_in_min as "time_to_next_stop_in_min", d.track_id, d.bus_stop_id as "from", d.next_stop_id as "to" from schedule.departures d join schedule.tracks t on t.id = d.track_id join schedule.routes r on r.id = t.route_id join schedule.bus_lines bl on bl.id = r.bus_line_id where d.next_stop_id is not null and bl.id NOT IN(152,164,165,166) and t.day_types like\'%RO%\'',
    );

    List<WalkEdgeEntity> walkEdgesEntityList = await _getWalkEdges();
    List<VehicleEdgeEntity> vehicleEdgesEntityList = result.map((Map<String, Map<String, dynamic>> fullRow) {
      Map<String, dynamic> parsedRow = _mergeMaps(fullRow.values.toList());
      StopEntity from = stops.firstWhere((StopEntity stop) => stop.id == parsedRow['from']);
      StopEntity to = stops.firstWhere((StopEntity stop) => stop.id == parsedRow['to']);
      List<map.LatLng> path = <map.LatLng>[map.LatLng(from.lat, from.lng), map.LatLng(to.lat, to.lng)];
      String polyline = GoogleCoordsUtils.encodePolyline(path);
      Distance distance = Haversine.calcDistance(map.LatLng(from.lat, from.lng), map.LatLng(to.lat, to.lng));
      return VehicleEdgeEntity.fromPostgresJson(parsedRow, distance.inMeters.toInt(), polyline);
    }).toList();

    await _saveEdgesToLocalFile(vehicleEdgesEntityList, walkEdgesEntityList);

    return <TransitEdgeEntity>[...vehicleEdgesEntityList, ...walkEdgesEntityList];
  }

  Map<String, dynamic> _mergeMaps(List<Map<String, dynamic>> maps) {
    Map<String, dynamic> result = <String, dynamic>{};
    for (Map<String, dynamic> map in maps) {
      result.addAll(map);
    }
    return result;
  }

  Future<List<WalkEdgeEntity>> _getWalkEdges() async {
    List<GetDirectionsResponse> getDirectionsResponses = await googleRepository.getAll();
    
    List<WalkEdgeEntity> walkEdges = List<WalkEdgeEntity>.empty(growable: true);
    
    for( GetDirectionsResponse getDirectionsResponse in getDirectionsResponses ) {
      int distanceInMeters = 0;
      List<String> polylinePoints = List<String>.empty(growable: true);
      for( RouteDto routeDto in getDirectionsResponse.routes ) {
        distanceInMeters += routeDto.distanceMeters;
        polylinePoints.add(routeDto.polylineDto.encodedPolyline);
      }
      WalkEdgeEntity walkEdge = WalkEdgeEntity(
        from: getDirectionsResponse.from,
        to: getDirectionsResponse.to,
        distanceInMeters: distanceInMeters,
        polylines: polylinePoints,
      );
      walkEdges.add(walkEdge);
    }
    
    print('WALK EDGES COUNT: ${walkEdges.length}');
    return walkEdges;
  }

  Future<void> _saveEdgesToLocalFile(List<VehicleEdgeEntity> vehicleEdges, List<WalkEdgeEntity> walkEdges) async {
    List<Map<String, dynamic>> allEdgesMapList = List<Map<String, dynamic>>.empty(growable: true);
    allEdgesMapList.addAll(vehicleEdges.map((VehicleEdgeEntity vehicleEdgeEntity) => vehicleEdgeEntity.toJson()));
    allEdgesMapList.addAll(walkEdges.map((WalkEdgeEntity walkEdgeEntity) => walkEdgeEntity.toJson()));

    await FileUtils.writeLocalFile('edges.json', jsonEncode(allEdgesMapList));
  }
}
