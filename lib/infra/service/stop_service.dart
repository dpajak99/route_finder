import 'package:latlong2/latlong.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/entity/stop_entity.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopService {
  final StopRepository stopRepository = getIt<StopRepository>();
  
  Future<List<StopVertex>> getAll() async {
    List<StopEntity> stopEntityList = await stopRepository.getAll();
    print('STOPS LENGTH: ${stopEntityList.length}');
    return stopEntityList.map((StopEntity stopEntity) => StopVertex(
      id: stopEntity.id.toString(),
      latLng: LatLng(stopEntity.lat, stopEntity.lng),
      name: stopEntity.name,
    )).toList();
  }
  
  Future<StopVertex> getRandomStopVertex() async {
    List<StopVertex> stopVertexList = await getAll();
    stopVertexList.shuffle();
    return stopVertexList.first;
  }
}