import 'package:path_finder/utils/algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/queue/priority_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dijkstra extends PathfinderAlgorithm<PriorityQueue<StopVertex>> {
  Dijkstra({
    required StopsGraph stopsGraph,
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required DateTime startTime,
  }) : super(
    stopsGraph: stopsGraph,
    sourceVertex: sourceVertex,
    targetVertex: targetVertex,
    startTime: startTime,
    unvisitedStopsQueue: PriorityQueue<StopVertex>(),
  );

  @override
  PathfinderResult searchPath() {
    clear();

    times[sourceVertex] = 0;
    costs[sourceVertex] = 0;
    unvisitedStopsQueue.add(sourceVertex, 0);

    while (unvisitedStopsQueue.isNotEmpty) {
      PriorityQueueElement<StopVertex> currentQueueElement = unvisitedStopsQueue.pop();
      StopVertex currentStopVertex = currentQueueElement.value;

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

      for (TransitEdge neighborEdge in neighbors) {
        bool isTransitAvailable = neighborEdge.canReachEdge(transitSearchPosition);
        if (isTransitAvailable == false) {
          continue;
        }

        StopVertex neighborVertex = neighborEdge.targetVertex;
        EdgeDetails edgeDetails = EdgeDetails.calcEdgeDetails(neighborEdge: neighborEdge, transitSearchPosition: transitSearchPosition);

        double previousTotalCostWithNeighbor = costs[neighborVertex] ?? double.infinity;
        bool hasBetterCost = edgeDetails.costFromStartToReachNeighbor < previousTotalCostWithNeighbor;
        bool firstNeighborVisit = costs[neighborVertex] == null;

        if (firstNeighborVisit || hasBetterCost) {
          // Update the previous vertex for the selected vertex
          visitedEdgesHistory[neighborVertex] = edgeDetails;

          // Update the distance and cost from the start vertex for the selected vertex
          times[neighborVertex] = edgeDetails.timeFromStartToReachNeighbor;
          costs[neighborVertex] = edgeDetails.costFromStartToReachNeighbor;

          unvisitedStopsQueue.add(neighborVertex, edgeDetails.costFromStartToReachNeighbor);
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
