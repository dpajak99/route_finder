import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_state.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/infra/service/edge_service.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/algorithms/dijkstra.dart';
import 'package:path_finder/utils/models/cost_config.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/markers/stop_marker.dart';
import 'package:path_finder/utils/models/markers/transit_stop_marker.dart';
import 'package:path_finder/utils/models/stops_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class GraphMapCubit extends Cubit<GraphMapState> {
  final StopSelectCubit stopSelectCubit = StopSelectCubit();
  
  final StopService _stopService = StopService();
  final EdgeService _edgeService = EdgeService();

  late StopsGraph stopsGraph;

  CostConfig costConfig = CostConfig();

  GraphMapCubit() : super(GraphMapLoadingState());

  Future<void> init() async {
    List<StopVertex> stopVertexList = await _stopService.getVertexList();
    stopsGraph = StopsGraph()..addStops(stopVertexList);
    emit(
      GraphMapLoadedState(markers: stopVertexList.map((StopVertex e) => StopMarker(stopVertex: e)).toList(), edges: const <TransitEdge>[]),
    );
  }

  Future<void> search() async {
    if( stopSelectCubit.state.isComplete == false ) {
      print('Error');
      return;
    }
    List<StopVertex> stopVertexList = await _stopService.getVertexList();
    List<VehicleEdge> edges = await _edgeService.getEdgesList(stopVertexList, stopSelectCubit.state.dateTime);
    stopsGraph = StopsGraph()
      ..addStops(stopVertexList)
      ..addEdgeIterable(edges);

    Dijkstra dijkstra = Dijkstra();
    DateTime dateTime = stopSelectCubit.state.dateTime;
    int minutes = 60 * dateTime.hour + dateTime.minute;
    
    List<TransitEdge> path = dijkstra.singleSourceShortestPaths(stopsGraph, stopSelectCubit.state.sourceVertex!, stopSelectCubit.state.targetVertex!, costConfig, minutes);
    List<StopMarker> markers = List<StopMarker>.empty(growable: true);
    for (int i = 0; i < path.length; i++) {
      TransitEdge edge = path[i];
      markers.add(TransitStopMarker(
        stopVertex: path[i].sourceVertex,
        transitEdge: edge,
      ));
    }

    emit(GraphMapSearchState(markers: markers, edges: path));
  }
}
