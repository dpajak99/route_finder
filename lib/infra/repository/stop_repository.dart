import 'package:path_finder/infra/entity/stop_entity.dart';

abstract class StopRepository {
  Future<StopEntity> getById(int id);
  
  Future<List<StopEntity>> getAll();
}