import 'package:latlong2/latlong.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/entity/transit_edge_entity.dart';
import 'package:path_finder/infra/entity/vehicle_edge_entity.dart';
import 'package:path_finder/infra/entity/walk_edge_entity.dart';
import 'package:path_finder/infra/repository/edge_repository.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class GraphService {
  final StopService stopService = getIt<StopService>();
  final EdgeRepository edgeRepository = getIt<EdgeRepository>();
  
  Future<MultiGraph<StopVertex, TransitEdge>> getFullTransitsGraph(int minutes) async {
    MultiGraph<StopVertex, TransitEdge> graph = MultiGraph<StopVertex, TransitEdge>();
    List<StopVertex> stopVertexList = await stopService.getAll();
    List<TransitEdge> transitEdgeList = await _getEdgesList(stopVertexList, minutes);
    
    graph.addVertexIterable(stopVertexList);
    graph.addEdgeIterable(transitEdgeList);
    
    return graph;
  }

  Future<MultiGraph<StopVertex, TransitEdge>> getFullTransitsGraphByLines(int minutes, List<String> lines) async {
    MultiGraph<StopVertex, TransitEdge> graph = MultiGraph<StopVertex, TransitEdge>();
    List<StopVertex> stopVertexList = await stopService.getAll();
    List<TransitEdge> transitEdgeList = await _getEdgesList(stopVertexList, minutes);
    
    List<TransitEdge> finalTransitEdgeList = <TransitEdge>[];
    Set<StopVertex> finalStopVertexList = <StopVertex>{};
    for(TransitEdge transitEdge in transitEdgeList ) {
      if( transitEdge is VehicleEdge && lines.contains(transitEdge.name) ) {
        finalTransitEdgeList.add(transitEdge);
        finalStopVertexList.add(transitEdge.sourceVertex);
        finalStopVertexList.add(transitEdge.targetVertex);
      }
    }
    
    for(TransitEdge transitEdge in transitEdgeList ) {
      if(transitEdge is WalkEdge && finalStopVertexList.contains(transitEdge.sourceVertex) && finalStopVertexList.contains(transitEdge.targetVertex)) {
        finalTransitEdgeList.add(transitEdge);
      }
    }

    graph.addVertexIterable(finalStopVertexList);
    graph.addEdgeIterable(finalTransitEdgeList);

    return graph;
  }

  Future<List<TransitEdge>> _getEdgesList(List<StopVertex> stopVertexList, int minutes) async {
    List<TransitEdgeEntity> edgesEntityList = await edgeRepository.getAll();
    List<TransitEdge> transitEdgeList = List<TransitEdge>.empty(growable: true);
    for (TransitEdgeEntity transitEdgeEntity in edgesEntityList) {
      StopVertex sourceVertex = stopVertexList.where((StopVertex e) => e.id == transitEdgeEntity.from.toString()).first;
      StopVertex targetVertex = stopVertexList.where((StopVertex e) => e.id == transitEdgeEntity.to.toString()).first;
      
      switch(transitEdgeEntity.runtimeType) {
        case VehicleEdgeEntity:
          VehicleEdgeEntity vehicleEdgeEntity = transitEdgeEntity as VehicleEdgeEntity;
          int timeFromNow = vehicleEdgeEntity.departureTimeInMin - minutes;
          if( timeFromNow >= 0 ) {
            transitEdgeList.add(VehicleEdge.fromEntity(vehicleEdgeEntity, sourceVertex, targetVertex, timeFromNow));
          }
          break;
        case WalkEdgeEntity:
          WalkEdgeEntity walkEdgeEntity = transitEdgeEntity as WalkEdgeEntity;
          transitEdgeList.add(WalkEdge.fromEntity(walkEdgeEntity, sourceVertex, targetVertex));
          break;  
        default:
          throw Exception('Unknown TransitEdgeEntity type');
      }
    }
    return transitEdgeList;
  }
}