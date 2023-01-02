import 'package:flutter/foundation.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

abstract class PathfinderAlgorithm<Q> {
  @protected
  final StopsGraph stopsGraph;

  @protected
  final StopVertex sourceVertex;

  @protected
  final StopVertex targetVertex;

  @protected
  final DateTime startTime;

  @protected
  final Map<StopVertex, double> times;

  @protected
  final Map<StopVertex, double> costs;

  @protected
  final Map<StopVertex, EdgeDetails> visitedEdgesHistory;

  @protected
  final List<StopVertex> visitedStopsHistory;
  
  @protected
  late Q unvisitedStopsQueue;
  
  PathfinderAlgorithm({
    required this.stopsGraph,
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
    required this.unvisitedStopsQueue,
  }) : times = <StopVertex, double>{},
       costs = <StopVertex, double>{},
       visitedEdgesHistory = <StopVertex, EdgeDetails>{},
       visitedStopsHistory = List<StopVertex>.empty(growable: true);

  PathfinderResult searchPath();
  
  @protected
  void clear() {
    times.clear();
    costs.clear();
    visitedEdgesHistory.clear();
    visitedStopsHistory.clear();
  }

  @protected
  List<EdgeDetails> buildPath() {
    // List to store the vertices in the shortest path
    List<EdgeDetails> path = <EdgeDetails>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list

    StopVertex currentVertex = targetVertex;
    while (currentVertex != sourceVertex) {
      EdgeDetails currentEdgeDetails = visitedEdgesHistory[currentVertex]!;
      path.add(currentEdgeDetails);
      currentVertex = currentEdgeDetails.transitEdge.sourceVertex;
    }

    return path.reversed.toList();
  }

  @protected
  void printPath(List<EdgeDetails> path) {
    for (EdgeDetails edgeDetails in path) {
      print(edgeDetails);
    }
  }
}