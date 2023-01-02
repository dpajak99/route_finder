import 'package:path_finder/utils/algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/queue/stack_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dfs extends PathfinderAlgorithm<StackQueue<StopVertex>> {
  Dfs({
    required StopsGraph stopsGraph,
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required DateTime startTime,
  }) : super(
    stopsGraph: stopsGraph,
    sourceVertex: sourceVertex,
    targetVertex: targetVertex,
    startTime: startTime,
    unvisitedStopsQueue: StackQueue<StopVertex>(),
  );

  @override
  PathfinderResult searchPath() {
    clear();
    List<TransitEdge> visited = List<TransitEdge>.empty(growable: true);

    times[sourceVertex] = 0;
    costs[sourceVertex] = 0;
    unvisitedStopsQueue.push(sourceVertex);

    while (unvisitedStopsQueue.isNotEmpty) {
      StopVertex currentStopVertex = unvisitedStopsQueue.pop();
      visitedStopsHistory.add(currentStopVertex);
      
      TransitSearchPosition transitSearchPosition = TransitSearchPosition(
        totalTimeFromStart: times[currentStopVertex] ?? 0,
        totalCostFromStart: costs[currentStopVertex] ?? 0,
        previousEdge: visitedEdgesHistory[currentStopVertex],
      );

      // If target vertex is found, we can stop searching
      if (currentStopVertex == targetVertex) {
        break;
      }

      List<TransitEdge> neighbors = stopsGraph[currentStopVertex];
      
      // Sort neighbors by lowest time to reach
      neighbors.sort((TransitEdge a, TransitEdge b) => a.transitStartTime.compareTo(b.transitStartTime));

      for (TransitEdge neighborEdge in neighbors) {
        bool isTransitAvailable = neighborEdge.canReachEdge(transitSearchPosition);
        if (isTransitAvailable == false) {
          continue;
        }
        

        if (!visited.contains(neighborEdge)) {
          StopVertex neighborVertex = neighborEdge.targetVertex;
          EdgeDetails edgeDetails = EdgeDetails.calcEdgeDetails(neighborEdge: neighborEdge, transitSearchPosition: transitSearchPosition);

          visited.add(neighborEdge);
          
          // Update the previous vertex for the selected vertex
          visitedEdgesHistory[neighborVertex] = edgeDetails;

          // Update the distance and cost from the start vertex for the selected vertex
          times[neighborVertex] = edgeDetails.timeFromStartToReachNeighbor;
          costs[neighborVertex] = edgeDetails.costFromStartToReachNeighbor;
          
          unvisitedStopsQueue.push(neighborEdge.targetVertex);
        }
      }
    }

    if (!visitedEdgesHistory.containsKey(targetVertex)) {
      throw Exception('Cannot find path from ${sourceVertex.id} to ${targetVertex.id}');
    }

    List<EdgeDetails> path = buildPath();
    printPath(path);

    return PathfinderResult(
      initialTime: startTime,
      path: path,
      visitedStopsHistory: visitedStopsHistory,
    );
  }
}
