import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_state.dart';
import 'package:path_finder/infra/service/edge_service.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/algorithms/dijkstra.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/markers/stop_marker.dart';
import 'package:path_finder/utils/models/markers/transit_stop_marker.dart';
import 'package:path_finder/utils/models/stops_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class GraphMapCubit extends Cubit<GraphMapState> {
  final StopService _stopService = StopService();
  final EdgeService _edgeService = EdgeService();

  late StopsGraph stopsGraph;

  GraphMapCubit() : super(GraphMapLoadingState());

  Future<void> init() async {
    List<StopVertex> stopVertexList = await _stopService.getVertexList();
    stopsGraph = StopsGraph()..addStops(stopVertexList);
    emit(
      GraphMapLoadedState(markers: stopVertexList.map((StopVertex e) => StopMarker(stopVertex: e)).toList(), edges: const <TransitEdge>[]),
    );
  }

  Future<void> search({required StopVertex source, required StopVertex target, required DateTime dateTime}) async {
    List<StopVertex> stopVertexList = await _stopService.getVertexList();
    List<VehicleEdge> edges = await _edgeService.getEdgesList(stopVertexList, dateTime);
    stopsGraph = StopsGraph()
      ..addStops(stopVertexList)
      ..addEdgeIterable(edges);

    Dijkstra dijkstra = Dijkstra();

    List<TransitEdge> path = dijkstra.singleSourceShortestPaths(stopsGraph, source, target);
    List<StopMarker> markers = List<StopMarker>.empty(growable: true);
    for (int i = 0; i < path.length; i++) {
      bool isLast = i == path.length - 1;
      TransitEdge edge = path[i];
      markers.add(TransitStopMarker(
        stopVertex: path[i].sourceVertex,
        transitEdge: edge,
      ));
    }

    emit(GraphMapSearchState(markers: markers, edges: path));
  }
}
