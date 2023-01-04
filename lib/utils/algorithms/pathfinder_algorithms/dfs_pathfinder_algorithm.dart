import 'package:flutter/foundation.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_algoritm_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_search_request.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/exception/no_route_exception.dart';
import 'package:path_finder/utils/exception/timeout_exception.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/queue/stack_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class DfsPathfinderAlgorithm extends PathfinderAlgorithm {
  DfsPathfinderAlgorithm({
    required super.stopsGraph,
    required super.sourceVertex,
    required super.targetVertex,
    required super.startTime,
  });

  @override
  Future<PathfinderAlgorithmResult> runSearch(PathfinderSearchRequest pathfinderSearchRequest) async {
    PathfinderAlgorithmResult pathfinderAlgorithmResult = await compute(_thread, pathfinderSearchRequest);
    return pathfinderAlgorithmResult;
  }
}

PathfinderAlgorithmResult _thread(PathfinderSearchRequest pathfinderSearchRequest) {
  StopsGraph stopsGraph = pathfinderSearchRequest.stopsGraph;
  StopVertex sourceVertex = pathfinderSearchRequest.sourceVertex;
  StopVertex targetVertex = pathfinderSearchRequest.targetVertex;
  Duration timeout = pathfinderSearchRequest.timeout;

  DateTime algorithmStartTime = DateTime.now();
  int visitedStopsCount = 0;

  Map<StopVertex, double> costs = <StopVertex, double>{};
  Map<StopVertex, double> times = <StopVertex, double>{};
  Map<StopVertex, EdgeDetails> previous = <StopVertex, EdgeDetails>{};

  List<StopVertex> visitedStops = List<StopVertex>.empty(growable: true);
  List<TransitEdge> visitedEdges = List<TransitEdge>.empty(growable: true);

  StackQueue<StopVertex> queue = StackQueue<StopVertex>();
  queue.push(sourceVertex);
  times[sourceVertex] = 0;
  costs[sourceVertex] = 0;

  while (queue.isNotEmpty) {
    StopVertex currentVertex = queue.pop();
    visitedStops.add(currentVertex);
    visitedStopsCount++;

    // Terminate based on timeout. We don't check the termination on every round, as it is
    // expensive to fetch the current time, compared to just running one more round.
    if (visitedStopsCount % 100 == 0 && algorithmStartTime.difference(DateTime.now()).abs() > timeout) {
      throw TimeoutException();
    }

    if (currentVertex == targetVertex) {
      break;
    }

    for (StopVertex neighborVertex in stopsGraph[currentVertex].keys) {
      for (TransitEdge transitEdge in stopsGraph[currentVertex][neighborVertex]!) {
        TransitSearchPosition transitSearchPosition = TransitSearchPosition(
          walkEdgeCostTable: pathfinderSearchRequest.walkEdgeCostTable,
          vehicleEdgeCostTable: pathfinderSearchRequest.vehicleEdgeCostTable,
          totalTimeFromStart: times[currentVertex]!,
          totalCostFromStart: costs[currentVertex]!,
          previousEdge: previous[currentVertex],
        );

        bool isTransitAvailable = transitEdge.canReachEdge(transitSearchPosition);
        if (isTransitAvailable == false) {
          continue;
        }

        if (!visitedEdges.contains(transitEdge)) {
          StopVertex neighborVertex = transitEdge.targetVertex;
          EdgeDetails edgeDetails = EdgeDetails.calcEdgeDetails(neighborEdge: transitEdge, transitSearchPosition: transitSearchPosition);

          visitedEdges.add(transitEdge);

          // Update the previous vertex for the selected vertex
          previous[neighborVertex] = edgeDetails;

          // Update the distance and cost from the start vertex for the selected vertex
          times[neighborVertex] = edgeDetails.timeFromStartToReachNeighbor;
          costs[neighborVertex] = edgeDetails.costFromStartToReachNeighbor;

          queue.push(transitEdge.targetVertex);
        }
      }
    }
  }

  if (previous.containsKey(targetVertex) == false) {
    throw NoRouteException();
  }

  return PathfinderAlgorithmResult(
    algorithmStartTime: algorithmStartTime,
    algorithmEndTime: DateTime.now(),
    visitedStopsCount: visitedStopsCount,
    previous: previous,
    visitedStopsHistory: visitedStops,
  );
}