import 'package:flutter/foundation.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_algoritm_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_search_request.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

abstract class PathfinderAlgorithm {
  static const Duration _timeout = Duration(seconds: 5);

  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();
  final MultiGraph<StopVertex, TransitEdge> graph;
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final DateTime startTime;

  PathfinderAlgorithm({
    required this.graph,
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
  });

  Future<PathfinderResult> searchPath() async {
    PathfinderSearchRequest pathfinderSearchRequest = PathfinderSearchRequest(
      vehicleEdgeCostTable: pathfinderSettingsCubit.state.vehicleEdgeCostTable,
      walkEdgeCostTable: pathfinderSettingsCubit.state.walkEdgeCostTable,
      timeout: _timeout,
      graph: graph,
      sourceVertex: sourceVertex,
      targetVertex: targetVertex,
      startTime: startTime,
    );
    PathfinderAlgorithmResult pathfinderAlgorithmResult = await runSearch(pathfinderSearchRequest);
    PathfinderResult pathfinderResult = PathfinderResult(
      pathfinderSettingsState: pathfinderSettingsCubit.state,
      pathfinderAlgorithmResult: pathfinderAlgorithmResult,
      path: buildPath(pathfinderAlgorithmResult.previous),
      initialTime: startTime,
    );
    return pathfinderResult;
  }

  @protected
  Future<PathfinderAlgorithmResult> runSearch(PathfinderSearchRequest pathfinderSearchRequest);
  
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