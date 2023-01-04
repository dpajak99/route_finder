import 'package:path_finder/infra/dto/vehicle_edge_dto.dart';
import 'package:path_finder/infra/postgres_database.dart';
import 'package:postgres/postgres.dart';

class EdgeRepository {
  PostgreSQLConnection sql = postgresDatabase.postgreSQLConnection;

  Future<List<VehicleEdgeDto>> getAllVehicleEdges(int minutes) async {
    List<Map<String, Map<String, dynamic>>> result = await sql.mappedResultsQuery(
      'select bl.name as "bus_name", d.time_in_min, d.time_in_min - $minutes as "time_from_now", d.time_to_next_stop_in_min, d.track_id, d.bus_stop_id as "from", d.next_stop_id as "to" from schedule.departures d join schedule.tracks t on t.id = d.track_id join schedule.routes r on r.id = t.route_id join schedule.bus_lines bl on bl.id = r.bus_line_id where d.next_stop_id is not null and d.time_in_min > $minutes and bl.id NOT IN(152,164,165,166)',
    );
    return result.map((Map<String, Map<String, dynamic>> fullRow) {
      return VehicleEdgeDto.fromJson(mergeMaps(fullRow.values.toList()));
    }).toList();
  }

  Map<String, dynamic> mergeMaps(List<Map<String, dynamic>> maps) {
    Map<String, dynamic> result = <String, dynamic>{};
    for (Map<String, dynamic> map in maps) {
      result.addAll(map);
    }
    return result;
  }
}
