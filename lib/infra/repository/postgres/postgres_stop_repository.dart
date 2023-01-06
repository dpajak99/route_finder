import 'dart:convert';

import 'package:path_finder/infra/entity/stop_entity.dart';
import 'package:path_finder/infra/postgres_database.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/utils/file_utils.dart';
import 'package:postgres/postgres.dart';

class PostgresStopRepository extends StopRepository {
  PostgreSQLConnection sql = postgresDatabase.postgreSQLConnection;
  
  @override
  Future<List<StopEntity>> getAll() async {
    List<Map<String, Map<String, dynamic>>> result = await sql.mappedResultsQuery('SELECT * FROM schedule.bus_stops bs where (bs.id in (SELECT DISTINCT d.bus_stop_id FROM schedule.departures d join schedule.tracks t on t.id = d.track_id join schedule.routes r on r.id = t.route_id where r.bus_line_id NOT IN(152,164,165,166)) or bs.id in (SELECT DISTINCT d.next_stop_id FROM schedule.departures d join schedule.tracks t on t.id = d.track_id join schedule.routes r on r.id = t.route_id where r.bus_line_id NOT IN(152,164,165,166)))');
    
    List<StopEntity> stopEntities = result.map((Map<String, Map<String, dynamic>> fullRow) {
      return StopEntity.fromJson(fullRow['bus_stops'] as Map<String, dynamic>);
    }).toList();

    await _saveStopsToLocalFile(stopEntities);
    
    return stopEntities;
  }
  
  Future<void> _saveStopsToLocalFile(List<StopEntity> stopEntities) async {
    List<Map<String, dynamic>> stopsMapList = stopEntities.map((StopEntity e) => e.toJson()).toList();
    await FileUtils.writeLocalFile('stops.json', jsonEncode(stopsMapList));
  }
}
