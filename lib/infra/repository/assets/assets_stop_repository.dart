import 'dart:convert';

import 'package:path_finder/infra/entity/stop_entity.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/utils/file_utils.dart';

class AssetsStopRepository extends StopRepository {

  List<StopEntity>? cachedStops;

  @override
  Future<StopEntity> getById(int id) async {
    List<StopEntity> stops = await getAll();
    return stops.firstWhere((StopEntity e) => e.id == id);
  }
  
  @override
  Future<List<StopEntity>> getAll() async {
    if( cachedStops != null ) {
      return cachedStops!;
    }
    String assetsEdges = await FileUtils.readAssetFile('stops.json');
    List<dynamic> stopsMap = jsonDecode(assetsEdges) as List<dynamic>;

    List<StopEntity> stopEntities = stopsMap.map((dynamic e) {
      Map<String, dynamic> stopMap = e as Map<String, dynamic>;
      return StopEntity.fromJson(stopMap);
    }).toList();

    cachedStops = stopEntities;
    return stopEntities;
  }
}
