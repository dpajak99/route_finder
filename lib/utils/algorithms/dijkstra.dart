import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/queue/priority_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dijkstra {
  final StopsGraph stopsGraph;
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final DateTime startTime;

  Dijkstra({
    required this.stopsGraph,
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
  });

  @override
  PathfinderResult searchPath() {
    Map<StopVertex, double> costs = <StopVertex, double>{};
    Map<StopVertex, double> times = <StopVertex, double>{};
    Map<StopVertex, EdgeDetails> previous = <StopVertex, EdgeDetails>{};

    PriorityQueue<StopVertex> queue = PriorityQueue<StopVertex>();
    queue.add(sourceVertex, 0);
    times[sourceVertex] = 0;
    costs[sourceVertex] = 0;

    while (queue.isNotEmpty) {
      StopVertex currentVertex = queue.pop().value;

      if (currentVertex == targetVertex) {
        break;
      }

      for (StopVertex nextStopVertex in stopsGraph[currentVertex].keys) {
        for (TransitEdge nextTransit in stopsGraph[currentVertex][nextStopVertex]!) {
          TransitSearchPosition transitSearchPosition = TransitSearchPosition(
            totalTimeFromStart: times[currentVertex]!,
            totalCostFromStart: costs[currentVertex]!,
            previousEdge: previous[currentVertex],
          );
          
          bool isTransitAvailable = nextTransit.canReachEdge(transitSearchPosition);
          if (isTransitAvailable == false) {
            continue;
          }
          double newTime = costs[currentVertex]! + nextTransit.calcTime(transitSearchPosition).total;
          double newCost = costs[currentVertex]! + nextTransit.calcCost(transitSearchPosition);

          EdgeDetails edgeDetails = EdgeDetails.calcEdgeDetails(neighborEdge: nextTransit, transitSearchPosition: transitSearchPosition);

          if (!costs.containsKey(nextStopVertex) || newCost < costs[nextStopVertex]!) {
            costs[nextStopVertex] = newCost;
            times[nextStopVertex] = newTime;
            previous[nextStopVertex] = edgeDetails;
            queue.add(nextStopVertex, newCost);
          }
        }
      }
    }

    List<EdgeDetails> path = buildPath(previous);
    printPath(path);

    return PathfinderResult(
      initialTime: startTime,
      path: path,
      visitedStopsHistory: List<StopVertex>.empty(growable: true),
    );
  }

  List<EdgeDetails> buildPath(Map<StopVertex, EdgeDetails> previous) {
    // List to store the vertices in the shortest path
    List<EdgeDetails> path = <EdgeDetails>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list

    StopVertex currentVertex = targetVertex;
    while (currentVertex != sourceVertex) {
      EdgeDetails currentEdgeDetails = previous[currentVertex]!;
      path.add(currentEdgeDetails);
      currentVertex = currentEdgeDetails.transitEdge.sourceVertex;
    }

    return path.reversed.toList();
  }

  void printPath(List<EdgeDetails> path) {
    for (EdgeDetails edgeDetails in path) {
      print(edgeDetails);
    }
  }
}
