import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/directed_graph.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/priority_queue.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dijkstra {
  List<VehicleEdge> singleSourceShortestPaths(DirectedGraph directedGraph, StopVertex startVertex, StopVertex endVertex) {
    // Priority queue to select the next vertex to visit
    // based on the distance from the start vertex
    PriorityQueue<StopVertex> queue = PriorityQueue<StopVertex>();

    queue.add(startVertex, 0);

    // Map to store the previous vertex for each vertex
    // in the shortest path from the start vertex
    Map<StopVertex, VehicleEdge> previous = <StopVertex, VehicleEdge>{};

    // Map to store the distance from the start vertex for each vertex
    // Map<StopVertex, double> distances = <StopVertex, double>{};
    Map<StopVertex, double> times = <StopVertex, double>{};

    // Set the initial distance for the start vertex to 0
    // distances[startVertex] = 0;
    times[startVertex] = 0;

    while (queue.isEmpty == false) {
      // Select the next vertex to visit based on the distance from the start vertex
      StopVertex currentVertex = queue.pop().value;

      double currentTotalTime = times[currentVertex] ?? 0;

      List<VehicleEdge> neighbors = directedGraph[currentVertex] ?? List<VehicleEdge>.empty();
      for (VehicleEdge edge in neighbors) {
        StopVertex neighborVertex = edge.toVertex;
        
        double timeToReachNeighbor = edge.timeFromNow.toDouble() - currentTotalTime;
        if( currentTotalTime != 0 && timeToReachNeighbor <= 0 ) {
          continue;
        } else if( currentTotalTime == 0 ) {
          currentTotalTime *= -1;
        }
        double totalTimeToReachNeighbor = currentTotalTime + timeToReachNeighbor;
        double previousTotalTimeWithNeighbor = times[neighborVertex] ?? double.infinity;
        bool hasBetterTime = totalTimeToReachNeighbor < previousTotalTimeWithNeighbor;
        bool firstNeighborVisit = times[neighborVertex] == null;
        
        if (firstNeighborVisit || hasBetterTime) {
          // Update the distance from the start vertex for the selected vertex
          times[neighborVertex] = totalTimeToReachNeighbor;
          queue.add(neighborVertex, totalTimeToReachNeighbor);
          // Update the previous vertex for the selected vertex
          previous[neighborVertex] = edge;
        }
      }
    }

    if (times[endVertex] == null) {
      throw Exception('Cannot find path from ${startVertex.id} to ${endVertex.id}');
    }

    // List to store the vertices in the shortest path
    List<VehicleEdge> path = <VehicleEdge>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list

    StopVertex currentVertex = endVertex;
    while (currentVertex != startVertex) {
      VehicleEdge? currentEdge = previous[currentVertex]!;
      path.add(currentEdge);
      currentVertex = currentEdge.fromVertex;
    }

    // Add the start vertex to the beginning of the list
    // path.insert(0, start);
    for (VehicleEdge edge in path.reversed) {
      print(edge);
    }
    // Return the list of vertices in the shortest path
    return path;
  }
}
