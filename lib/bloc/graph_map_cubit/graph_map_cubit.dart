import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_state.dart';
import 'package:path_finder/infra/service/edge_service.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/algorithms/a_star.dart';
import 'package:path_finder/utils/algorithms/dijkstra.dart';
import 'package:path_finder/utils/models/directed_graph.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class GraphMapCubit extends Cubit<GraphMapState> {
  final StopService _stopService = StopService();
  final EdgeService _edgeService = EdgeService();

  GraphMapCubit() : super(GraphMapLoadingState());

  Future<void> init() async {
    List<StopVertex> stopVertexList = await _stopService.getVertexList();
    List<VehicleEdge> edges = await _edgeService.getEdgesList(stopVertexList);
    DirectedGraph directedGraph = DirectedGraph()
      ..addVertexIterable(stopVertexList)
      ..addEdgeIterable(edges);
    emit(GraphMapLoadedState(vertices: stopVertexList, directedGraph: directedGraph));
  }
  
  StopVertex? startVertex;
  StopVertex? endVertex;
  
  void addVertex(StopVertex stopVertex) {
    if( startVertex == null ) {
      print('selected start vertex: $stopVertex');
      startVertex = stopVertex;
    } else if( endVertex == null ) {
      print('selected end vertex: $stopVertex');
      endVertex = stopVertex;
      if( state is GraphMapLoadedState ) {
        Dijkstra dijkstra = Dijkstra();
        dijkstra.singleSourceShortestPaths((state as GraphMapLoadedState).directedGraph, startVertex!, endVertex!);
      }
      startVertex = null;
      endVertex = null;
    }
  }
}
