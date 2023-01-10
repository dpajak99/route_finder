import 'package:flutter/foundation.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_algoritm_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_search_request.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/exception/no_route_exception.dart';
import 'package:path_finder/utils/exception/timeout_exception.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/queue/stack_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class DfsPathfinderAlgorithm extends PathfinderAlgorithm {
  DfsPathfinderAlgorithm({
    required super.graph,
    required super.sourceVertex,
    required super.targetVertex,
    required super.startTime,
  });

  @override
  Future<PathfinderAlgorithmResult> runSearch(PathfinderSearchRequest pathfinderSearchRequest, {bool stopWhetTarget = true}) async {
    MultiGraph<StopVertex, TransitEdge> graph = pathfinderSearchRequest.graph;
    StopVertex sourceVertex = pathfinderSearchRequest.sourceVertex;
    StopVertex targetVertex = pathfinderSearchRequest.targetVertex;

    DateTime algorithmStartTime = DateTime.now();
    int visitedStopsCount = 0;

    Map<StopVertex, double> costs = <StopVertex, double>{};
    Map<StopVertex, double> times = <StopVertex, double>{};
    Map<StopVertex, EdgeDetails> previous = <StopVertex, EdgeDetails>{};

    List<StopVertex> visitedStops = List<StopVertex>.empty(growable: true);
    List<StopVertex> bfsVisitedStops = List<StopVertex>.empty(growable: true);

    StackQueue<StopVertex> queue = StackQueue<StopVertex>();
    queue.push(sourceVertex);
    times[sourceVertex] = 0;
    costs[sourceVertex] = 0;

    while (queue.isNotEmpty) {
      StopVertex currentVertex = queue.pop();
      visitedStops.add(currentVertex);
      visitedStopsCount++;

      if (stopWhetTarget && currentVertex == targetVertex) {
        break;
      }
      for (StopVertex neighborVertex in graph[currentVertex].keys) {
        if (bfsVisitedStops.contains(neighborVertex)) {
          continue;
        }
        AlgorithmSearchState transitSearchPosition = AlgorithmSearchState(
          walkEdgeCostTable: pathfinderSearchRequest.walkEdgeCostTable,
          vehicleEdgeCostTable: pathfinderSearchRequest.vehicleEdgeCostTable,
          totalTimeFromStart: times[currentVertex]!,
          totalCostFromStart: costs[currentVertex]!,
          previousEdge: previous[currentVertex],
        );

        List<TransitEdge> availableEdges = graph[currentVertex][neighborVertex]!;
        EdgeDetails? lowestEdgeDetails = _calcLowestEdgeCost(availableEdges, transitSearchPosition);
        if (lowestEdgeDetails == null) {
          continue;
        }
        
        
        bfsVisitedStops.add(neighborVertex);
        costs[neighborVertex] = lowestEdgeDetails.costFromStartToReachNeighbor;
        times[neighborVertex] = lowestEdgeDetails.timeFromStartToReachNeighbor;
        previous[neighborVertex] = lowestEdgeDetails;
        queue.push(neighborVertex);
      }
    }

    if (previous.containsKey(targetVertex) == false) {
      throw NoRouteException();
    }

    return PathfinderAlgorithmResult(
      algorithmStartTime: algorithmStartTime,
      visitedStopsCount: visitedStopsCount,
      previous: previous,
      costs: costs,
      times: times,
      visitedStopsHistory: visitedStops,
    );
  }

  EdgeDetails? _calcLowestEdgeCost(List<TransitEdge> availableEdges, AlgorithmSearchState transitSearchPosition) {
    double lowestCost = double.infinity;
    EdgeDetails? lowestEdgeDetails;
    availableEdges.sort((TransitEdge a, TransitEdge b) => a is WalkEdge ? -1 : 1);
    for (TransitEdge transitEdge in availableEdges) {
      bool isTransitAvailable = transitEdge.canReachEdge(transitSearchPosition);
      if (isTransitAvailable == false) {
        continue;
      }
      EdgeDetails edgeDetails = EdgeDetails.calcEdgeDetails(neighborEdge: transitEdge, transitSearchPosition: transitSearchPosition);
      double newCost = edgeDetails.costFromStartToReachNeighbor;
      if (newCost < lowestCost) {
        lowestCost = newCost;
        lowestEdgeDetails = edgeDetails;
      }
    }
    return lowestEdgeDetails;
  }
}