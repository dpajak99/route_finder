import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_algoritm_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_search_request.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/exception/no_route_exception.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/queue/priority_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class DijkstraPathfinderAlgorithm extends PathfinderAlgorithm {
  DijkstraPathfinderAlgorithm({
    required super.graph,
    required super.sourceVertex,
    required super.targetVertex,
    required super.startTime,
  });

  @override
  Future<PathfinderAlgorithmResult> runSearch(PathfinderSearchRequest pathfinderSearchRequest) async {
    MultiGraph<StopVertex, TransitEdge>  graph = pathfinderSearchRequest.graph;
    StopVertex sourceVertex = pathfinderSearchRequest.sourceVertex;
    StopVertex targetVertex = pathfinderSearchRequest.targetVertex;
    Duration timeout = pathfinderSearchRequest.timeout;

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


      // Terminate based on timeout. We don't check the termination on every round, as it is
      // expensive to fetch the current time, compared to just running one more round.
      // if (visitedStopsCount % 100 == 0 && algorithmStartTime.difference(DateTime.now()).abs() > timeout) {
      //   throw TimeoutException();
      // }

      if (currentVertex == targetVertex) {
        break;
      }

      for (StopVertex neighborVertex in graph[currentVertex].keys) {
        for (TransitEdge transitEdge in graph[currentVertex][neighborVertex]!) {
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

          EdgeDetails edgeDetails = EdgeDetails.calcEdgeDetails(neighborEdge: transitEdge, transitSearchPosition: transitSearchPosition);

          double newTime = edgeDetails.timeFromStartToReachNeighbor;
          double newCost = edgeDetails.costFromStartToReachNeighbor;

          double previousCost = costs[neighborVertex] ?? double.infinity;

          bool firstNeighborVisit = costs.containsKey(neighborVertex) == false;
          bool hasBetterCost = newCost < previousCost;
          if (firstNeighborVisit || hasBetterCost) {
            costs[neighborVertex] = newCost;
            times[neighborVertex] = newTime;
            previous[neighborVertex] = edgeDetails;
            queue.add(neighborVertex, newCost);
          }
        }
      }
    }

    if(previous.containsKey(targetVertex) == false) {
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
}