import 'package:path_finder/infra/entity/stop_entity.dart';

abstract class StopRepository {
  Future<List<StopEntity>> getAll();
}