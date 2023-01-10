import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_algoritm_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_search_request.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/exception/no_route_exception.dart';
import 'package:path_finder/utils/models/distance.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/queue/priority_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class AStarPathfinderAlgorithm extends PathfinderAlgorithm {
  AStarPathfinderAlgorithm({
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

    PriorityQueue<StopVertex> queue = PriorityQueue<StopVertex>();
    queue.add(sourceVertex, 0);
    times[sourceVertex] = 0;
    costs[sourceVertex] = 0;

    while (queue.isNotEmpty) {
      StopVertex currentVertex = queue.pop().value;
      visitedStops.add(currentVertex);
      visitedStopsCount++;

      if (stopWhetTarget && currentVertex == targetVertex) {
        break;
      }

      for (StopVertex neighborVertex in graph[currentVertex].keys) {
        AlgorithmSearchState transitSearchPosition = AlgorithmSearchState(
          walkEdgeCostTable: pathfinderSearchRequest.walkEdgeCostTable,
          vehicleEdgeCostTable: pathfinderSearchRequest.vehicleEdgeCostTable,
          totalTimeFromStart: times[currentVertex]!,
          totalCostFromStart: costs[currentVertex]!,
          previousEdge: previous[currentVertex],
        );

        List<TransitEdge> availableEdges = graph[currentVertex][neighborVertex]!;
        EdgeDetails? lowestEdgeDetails = _calcLowestEdgeCost(availableEdges, transitSearchPosition, neighborVertex);
        if (lowestEdgeDetails == null) {
          continue;
        }
        double newCost = lowestEdgeDetails.costFromStartToReachNeighbor;
        double previousCost = costs[neighborVertex] ?? double.infinity;
        
        bool firstNeighborVisit = costs.containsKey(neighborVertex) == false;
        bool hasBetterCost = newCost < previousCost;
        if (firstNeighborVisit || hasBetterCost) {
          costs[neighborVertex] = newCost;
          times[neighborVertex] = lowestEdgeDetails.timeFromStartToReachNeighbor;
          previous[neighborVertex] = lowestEdgeDetails;
          queue.add(neighborVertex, newCost);
        }
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

  EdgeDetails? _calcLowestEdgeCost(List<TransitEdge> availableEdges, AlgorithmSearchState transitSearchPosition, StopVertex neighborVertex) {
    double lowestCost = double.infinity;
    EdgeDetails? lowestEdgeDetails;
    for (TransitEdge transitEdge in availableEdges) {
      bool isTransitAvailable = transitEdge.canReachEdge(transitSearchPosition);
      if (isTransitAvailable == false) {
        continue;
      }
      double heuristicCost = _calcHeuristicCost(neighborVertex, targetVertex).inKilometers * 0.1;

      EdgeDetails edgeDetails = EdgeDetails.calcEdgeDetails(
        neighborEdge: transitEdge,
        transitSearchPosition: transitSearchPosition,
        heuristicCost: heuristicCost,
      );

      double newCost = edgeDetails.costFromStartToReachNeighbor;
      if (newCost < lowestCost) {
        lowestCost = newCost;
        lowestEdgeDetails = edgeDetails;
      }
    }
    return lowestEdgeDetails;
  }

  Distance _calcHeuristicCost(StopVertex sourceVertex, StopVertex targetVertex) {
    return Haversine.calcDistance(sourceVertex.latLng, targetVertex.latLng);
  }
}
