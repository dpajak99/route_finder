import 'package:path_finder/infra/entity/stop_entity.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopService {
  final StopRepository stopRepository = StopRepository();

  Future<StopVertex> getById(int id) async {
    StopEntity stopEntity = await stopRepository.getById(id);
    return StopVertex(
      id: stopEntity.id.toString(),
      lat: stopEntity.lat,
      long: stopEntity.lng,
      name: stopEntity.name,
    );
  }
  
  Future<List<StopVertex>> getVertexList() async {
    List<StopEntity> stopEntityList = await stopRepository.getAll();
    return stopEntityList.map((StopEntity stopEntity) => StopVertex(
      id: stopEntity.id.toString(),
      lat: stopEntity.lat,
      long: stopEntity.lng,
      name: stopEntity.name,
    )).toList();
  }
}