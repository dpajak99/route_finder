import 'package:flutter/foundation.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

abstract class PathfinderAlgorithm {
  static const Duration _timeout = Duration(seconds: 5);
  
  final StopsGraph stopsGraph;
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final DateTime startTime;

  PathfinderAlgorithm({
    required this.stopsGraph,
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
  });

  Future<PathfinderResult> searchPath() async {
    PathfinderResult pathfinderResult = runSearch(_timeout);
    return pathfinderResult;
  }

  @protected
  PathfinderResult runSearch(Duration timeout);
  
  @protected
  List<EdgeDetails> buildPath(Map<StopVertex, EdgeDetails> previous) {
    // List to store the vertices in the shortest path
    List<EdgeDetails> path = <EdgeDetails>[];
    
    StopVertex currentVertex = targetVertex;
    while (currentVertex != sourceVertex) {
      EdgeDetails currentEdgeDetails = previous[currentVertex]!;
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