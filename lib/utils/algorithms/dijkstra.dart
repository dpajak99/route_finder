import 'package:path_finder/utils/algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/exception/no_route_exception.dart';
import 'package:path_finder/utils/exception/timeout_exception.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/queue/priority_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dijkstra extends PathfinderAlgorithm {
  Dijkstra({
    required super.stopsGraph,
    required super.sourceVertex,
    required super.targetVertex,
    required super.startTime,
  });
  
  @override
  PathfinderResult runSearch(Duration timeout) {
    DateTime algorithmStartTime = DateTime.now();
    int visitedVertexCount = 0;
    
    Map<StopVertex, double> costs = <StopVertex, double>{};
    Map<StopVertex, double> times = <StopVertex, double>{};
    Map<StopVertex, EdgeDetails> previous = <StopVertex, EdgeDetails>{};

    PriorityQueue<StopVertex> queue = PriorityQueue<StopVertex>();
    queue.add(sourceVertex, 0);
    times[sourceVertex] = 0;
    costs[sourceVertex] = 0;

    while (queue.isNotEmpty) {
      StopVertex currentVertex = queue.pop().value;
      visitedVertexCount++;


      // Terminate based on timeout. We don't check the termination on every round, as it is
      // expensive to fetch the current time, compared to just running one more round.
      if (visitedVertexCount % 100 == 0 && algorithmStartTime.difference(DateTime.now()).abs() > timeout) {
        throw TimeoutException();
      }
      
      if (currentVertex == targetVertex) {
        break;
      }

      for (StopVertex neighborVertex in stopsGraph[currentVertex].keys) {
        for (TransitEdge transitEdge in stopsGraph[currentVertex][neighborVertex]!) {
          TransitSearchPosition transitSearchPosition = TransitSearchPosition(
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
    
    return PathfinderResult(
      initialTime: startTime,
      algorithmStartTime: algorithmStartTime,
      algorithmEndTime: DateTime.now(),
      visitedVertexCount: visitedVertexCount,
      path: buildPath(previous),
      visitedStopsHistory: List<StopVertex>.empty(growable: true),
    );
  }
}
