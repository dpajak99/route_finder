import 'package:path_finder/utils/models/cost_config.dart';
import 'package:path_finder/utils/models/cost_table.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/priority_queue.dart';
import 'package:path_finder/utils/models/stops_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dijkstra {
  List<TransitEdgeResult> singleSourceShortestPaths(
      StopsGraph stopsGraph, StopVertex startVertex, StopVertex endVertex, CostConfig costConfig, int currentTimeInMin) {
    // Priority queue to select the next vertex to visit
    // based on the distance from the start vertex
    PriorityQueue<StopVertex> unvisitedStopsQueue = PriorityQueue<StopVertex>();

    unvisitedStopsQueue.add(startVertex, 0);

    // Map to store the previous vertex for each vertex
    // in the shortest path from the start vertex
    Map<StopVertex, TransitEdgeResult> previous = <StopVertex, TransitEdgeResult>{};

    // Map to store the distance from the start vertex for each vertex
    // Map<StopVertex, double> distances = <StopVertex, double>{};
    Map<StopVertex, int> times = <StopVertex, int>{};
    Map<StopVertex, double> costs = <StopVertex, double>{};

    // Set the initial distance for the start vertex to 0
    times[startVertex] = 0;
    costs[startVertex] = 0;

    while (unvisitedStopsQueue.isEmpty == false) {
      // Select the next vertex to visit based on the distance from the start vertex
      StopVertex currentStopVertex = unvisitedStopsQueue.pop().value;
      TransitEdgeResult? previousEdgeResult = previous[currentStopVertex];

      int currentTotalTime = times[currentStopVertex] ?? 0;
      double currentTotalCost = costs[currentStopVertex] ?? 0;

      List<TransitEdge> neighbors = stopsGraph[currentStopVertex] ?? List<TransitEdge>.empty();
      for (TransitEdge neighborEdge in neighbors) {
        bool isTransitAvailable = neighborEdge.isTransitAvailable(previousEdgeResult, currentTotalTime);
        if (isTransitAvailable == false) {
          continue;
        }

        StopVertex neighborVertex = neighborEdge.targetVertex;
        CostTable costTable = neighborEdge.buildCostTable(previousEdgeResult?.transitEdge, currentTotalTime);

        FullEdgeTime fullEdgeTime = neighborEdge.calcFullEdgeTime(currentTotalTime);
        int timeFromStartToReachNeighbor = currentTotalTime + fullEdgeTime.total;

        double edgeCost = costTable.calcCost(costConfig);
        double costFromStartToReachNeighbor = currentTotalCost + edgeCost;
 
        double previousTotalCostWithNeighbor = costs[neighborVertex] ?? double.infinity;

        bool hasBetterCost = costFromStartToReachNeighbor < previousTotalCostWithNeighbor;
        bool firstNeighborVisit = costs[neighborVertex] == null;

        if (firstNeighborVisit || hasBetterCost) {
          // Update the previous vertex for the selected vertex
          previous[neighborVertex] = TransitEdgeResult(
            currentTime: currentTimeInMin,
            transitEdge: neighborEdge,
            totalCost: costFromStartToReachNeighbor,
            totalTime: timeFromStartToReachNeighbor,
            edgeCost: edgeCost,
            edgeTime: fullEdgeTime.total,
            edgeTimeStart: currentTotalTime,
            edgeTimeWait: fullEdgeTime.waitingTime,
            edgeTimeTransit: fullEdgeTime.transitTime,
            edgeTimeEnd: timeFromStartToReachNeighbor,
          );
          
          // Update the distance from the start vertex for the selected vertex
          times[neighborVertex] = timeFromStartToReachNeighbor;
          costs[neighborVertex] = costFromStartToReachNeighbor;

          unvisitedStopsQueue.add(neighborVertex, costFromStartToReachNeighbor);
        }
      }
    }

    if (costs[endVertex] == null) {
      throw Exception('Cannot find path from ${startVertex.id} to ${endVertex.id}');
    }

    // List to store the vertices in the shortest path
    List<TransitEdgeResult> path = <TransitEdgeResult>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list

    StopVertex currentVertex = endVertex;
    while (currentVertex != startVertex) {
      TransitEdgeResult? currentEdge = previous[currentVertex]!;
      path.add(currentEdge);
      currentVertex = currentEdge.transitEdge.sourceVertex;
    }

    // Add the start vertex to the beginning of the list
    // path.insert(0, start);
    for (TransitEdgeResult edgeResult in path.reversed) {
      print(edgeResult);
    }

    // PathFinderResult result = PathFinderResult.fromEdges(path.reversed.toList());
    // result.printRoute();
    // Return the list of vertices in the shortest path
    return path.reversed.toList();
  }
}
