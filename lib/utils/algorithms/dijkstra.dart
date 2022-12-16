import 'dart:math';

import 'package:path_finder/utils/models/cost_config.dart';
import 'package:path_finder/utils/models/cost_table.dart';
import 'package:path_finder/utils/models/edge/parsed_walk_edge.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/priority_queue.dart';
import 'package:path_finder/utils/models/stops_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dijkstra {
  List<TransitEdge> singleSourceShortestPaths(StopsGraph stopsGraph, StopVertex startVertex, StopVertex endVertex) {
    CostConfig costConfig = CostConfig();
    
    // Priority queue to select the next vertex to visit
    // based on the distance from the start vertex
    PriorityQueue<StopVertex> unvisitedStopsQueue = PriorityQueue<StopVertex>();

    unvisitedStopsQueue.add(startVertex, 0);

    // Map to store the previous vertex for each vertex
    // in the shortest path from the start vertex
    Map<StopVertex, TransitEdge> previous = <StopVertex, TransitEdge>{};

    // Map to store the distance from the start vertex for each vertex
    // Map<StopVertex, double> distances = <StopVertex, double>{};
    Map<StopVertex, double> times = <StopVertex, double>{};
    Map<StopVertex, double> costs = <StopVertex, double>{};

    // Set the initial distance for the start vertex to 0
    times[startVertex] = 0;
    costs[startVertex] = 0;

    while (unvisitedStopsQueue.isEmpty == false) {
      // Select the next vertex to visit based on the distance from the start vertex
      StopVertex currentStopVertex = unvisitedStopsQueue.pop().value;
      TransitEdge? previousTransitEdge = previous[currentStopVertex];

      double currentTotalTime = times[currentStopVertex] ?? 0;
      double currentTotalCost = costs[currentStopVertex] ?? 0;

      List<TransitEdge> neighbors = stopsGraph[currentStopVertex] ?? List<TransitEdge>.empty();
      for (TransitEdge neighborEdge in neighbors) {
        bool isTransitAvailable = neighborEdge.isTransitAvailable(previousTransitEdge, currentTotalTime);
        if(isTransitAvailable == false) {
          continue;
        }
        StopVertex neighborVertex = neighborEdge.targetVertex;

        CostTable costTable = neighborEdge.getCostTable(previousTransitEdge, currentTotalTime);
        
        double transferTime = neighborEdge.distanceTime;
        double transitCost = costTable.calcCost(costConfig);
        
        double totalTimeToReachNeighbor = currentTotalTime + transferTime;
        double totalCostToReachNeighbor = currentTotalCost + transitCost;
        
        double previousTotalCostWithNeighbor = costs[neighborVertex] ?? double.infinity;
        
        bool hasBetterCost = totalCostToReachNeighbor < previousTotalCostWithNeighbor;
        bool firstNeighborVisit = costs[neighborVertex] == null;
        
        if (firstNeighborVisit || hasBetterCost) {
          // Update the distance from the start vertex for the selected vertex
          times[neighborVertex] = totalTimeToReachNeighbor;
          costs[neighborVertex] = totalCostToReachNeighbor;
          
          unvisitedStopsQueue.add(neighborVertex, totalCostToReachNeighbor);
          // Update the previous vertex for the selected vertex
          if( neighborEdge is WalkEdge ) {
            previous[neighborVertex] = ParsedWalkEdge.fromWalkEdge(neighborEdge, currentTotalTime.toInt());
          } else {
            previous[neighborVertex] = neighborEdge;
          }
        }
      }
    }

    if (costs[endVertex] == null) {
      throw Exception('Cannot find path from ${startVertex.id} to ${endVertex.id}');
    }

    // List to store the vertices in the shortest path
    List<TransitEdge> path = <TransitEdge>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list

    StopVertex currentVertex = endVertex;
    while (currentVertex != startVertex) {
      TransitEdge? currentEdge = previous[currentVertex]!;
      path.add(currentEdge);
      currentVertex = currentEdge.sourceVertex;
    }

    // Add the start vertex to the beginning of the list
    // path.insert(0, start);
    PathFinderResult result = PathFinderResult.fromEdges(path.reversed.toList());
    result.printRoute();
    // Return the list of vertices in the shortest path
    return path;
  }
}
