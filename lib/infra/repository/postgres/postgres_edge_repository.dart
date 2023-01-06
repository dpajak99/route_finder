import 'dart:convert';

import 'package:latlong2/latlong.dart' as map;
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/entity/stop_entity.dart';
import 'package:path_finder/infra/entity/transit_edge_entity.dart';
import 'package:path_finder/infra/entity/vehicle_edge_entity.dart';
import 'package:path_finder/infra/entity/walk_edge_entity.dart';
import 'package:path_finder/infra/postgres_database.dart';
import 'package:path_finder/infra/repository/edge_repository.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/file_utils.dart';
import 'package:postgres/postgres.dart';

class PostgresEdgeRepository extends EdgeRepository {
  static const double maxWalkingDistanceInMeters = 3000;

  final PostgreSQLConnection sql = postgresDatabase.postgreSQLConnection;
  final StopRepository stopRepository = getIt<StopRepository>();

  @override
  Future<List<TransitEdgeEntity>> getAll() async {
    List<Map<String, Map<String, dynamic>>> result = await sql.mappedResultsQuery(
      'select bl.name as "bus_name", d.time_in_min, d.time_to_next_stop_in_min, d.track_id, d.bus_stop_id as "from", d.next_stop_id as "to" from schedule.departures d join schedule.tracks t on t.id = d.track_id join schedule.routes r on r.id = t.route_id join schedule.bus_lines bl on bl.id = r.bus_line_id where d.next_stop_id is not null and bl.id NOT IN(152,164,165,166) and t.day_types like\'%RO%\'',
    );

    List<WalkEdgeEntity> walkEdgesEntityList = await _getWalkEdges();
    List<VehicleEdgeEntity> vehicleEdgesEntityList = result.map((Map<String, Map<String, dynamic>> fullRow) {
      Map<String, dynamic> parsedRow = _mergeMaps(fullRow.values.toList());
      return VehicleEdgeEntity.fromJson(parsedRow);
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
    List<StopEntity> stopEntities = await stopRepository.getAll();
    List<WalkEdgeEntity> walkEdges = List<WalkEdgeEntity>.empty(growable: true);

    for (StopEntity sourceStop in stopEntities) {
      for (StopEntity targetStop in stopEntities) {
        if (sourceStop != targetStop) {
          map.LatLng sourceLatLng = map.LatLng(sourceStop.lat, sourceStop.lng);
          map.LatLng targetLatLng = map.LatLng(targetStop.lat, targetStop.lng);

          WalkEdgeEntity walkEdge = WalkEdgeEntity(
            from: sourceStop.id,
            to: targetStop.id,
            distanceInMeters: Haversine.calcDistance(sourceLatLng, targetLatLng).inMeters,
          );

          if (walkEdge.distanceInMeters < maxWalkingDistanceInMeters) {
            walkEdges.add(walkEdge);
          }
        }
      }
    }
    return walkEdges;
  }

  Future<void> _saveEdgesToLocalFile(List<VehicleEdgeEntity> vehicleEdges, List<WalkEdgeEntity> walkEdges) async {
    List<Map<String, dynamic>> allEdgesMapList = List<Map<String, dynamic>>.empty(growable: true);
    allEdgesMapList.addAll(vehicleEdges.map((VehicleEdgeEntity vehicleEdgeEntity) => vehicleEdgeEntity.toJson()));
    allEdgesMapList.addAll(walkEdges.map((WalkEdgeEntity walkEdgeEntity) => walkEdgeEntity.toJson()));

    await FileUtils.writeLocalFile('edges.json', jsonEncode(allEdgesMapList));
  }
}
