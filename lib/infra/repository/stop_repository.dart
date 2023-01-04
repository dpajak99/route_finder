import 'package:path_finder/infra/entity/stop_entity.dart';
import 'package:path_finder/infra/postgres_database.dart';
import 'package:postgres/postgres.dart';

class StopRepository {
  PostgreSQLConnection sql = postgresDatabase.postgreSQLConnection;

  Future<StopEntity> getById(int id) async {
      List<Map<String, Map<String, dynamic>>> result = await sql.mappedResultsQuery(
          'SELECT * FROM schedule.bus_stops bs WHERE id = @id', substitutionValues: <String, dynamic>{'id': id});
      Map<String, dynamic> row = result.single['bus_stops'] as Map<String, dynamic>;
      return StopEntity.fromJson(row);
  }

  Future<List<StopEntity>> getAll() async {
    List<Map<String, Map<String, dynamic>>> result = await sql.mappedResultsQuery('SELECT * FROM schedule.bus_stops bs WHERE bs.lat is not null AND bs.lng is not null and bs.id in (SELECT DISTINCT d.bus_stop_id FROM schedule.departures d join schedule.tracks t on t.id = d.track_id join schedule.routes r on r.id = t.route_id where r.bus_line_id NOT IN(152,164,165,166))');
    return result.map((Map<String, Map<String, dynamic>> fullRow) {
      return StopEntity.fromJson(fullRow['bus_stops'] as Map<String, dynamic>);
    }).toList();
  }
}
