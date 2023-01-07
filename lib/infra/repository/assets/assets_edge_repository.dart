import 'dart:convert';

import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/entity/transit_edge_entity.dart';
import 'package:path_finder/infra/entity/vehicle_edge_entity.dart';
import 'package:path_finder/infra/entity/walk_edge_entity.dart';
import 'package:path_finder/infra/repository/edge_repository.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/utils/file_utils.dart';

class AssetsEdgeRepository extends EdgeRepository {
  static const double maxWalkingDistanceInMeters = 3000;

  final StopRepository stopRepository = getIt<StopRepository>();
  
  List<TransitEdgeEntity>? cachedEdges;

  @override
  Future<List<TransitEdgeEntity>> getAll() async {
    if( cachedEdges != null ) {
      return cachedEdges!;
    }
    String assetsEdges = await FileUtils.readAssetFile('edges.json');
    List<dynamic> edgesMap = jsonDecode(assetsEdges) as List<dynamic>;

    List<TransitEdgeEntity> transitEdgesEntity = edgesMap.map((dynamic e) {
      Map<String, dynamic> edgeMap = e as Map<String, dynamic>;
      if(edgeMap['type'] == 'walk') {
        return WalkEdgeEntity.fromJson(edgeMap);
      } else if(edgeMap['type'] == 'vehicle') {
        return VehicleEdgeEntity.fromAssetsJson(edgeMap);
      } else {
        throw Exception('Unknown TransitEdgeEntity type');
      }
    }).toList();
    
    cachedEdges = transitEdgesEntity;
    print('ALL EDGES COUNT: ${transitEdgesEntity.length}');
    return transitEdgesEntity;
  }
}
