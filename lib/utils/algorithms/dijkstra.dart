import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/directed_graph.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/priority_queue.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Dijkstra {
  List<VehicleEdge> singleSourceShortestPaths(DirectedGraph directedGraph, StopVertex startVertex, StopVertex endVertex) {
    // Priority queue to select the next vertex to visit
    // based on the distance from the start vertex
    PriorityQueue<VehicleEdge> queue = PriorityQueue<VehicleEdge>();

    // Map to store the previous vertex for each vertex
    // in the shortest path from the start vertex
    Map<StopVertex, VehicleEdge> previous = <StopVertex, VehicleEdge>{};

    // Map to store the distance from the start vertex for each vertex
    // Map<StopVertex, double> distances = <StopVertex, double>{};
    Map<StopVertex, double> times = <StopVertex, double>{};

    // Set the initial distance for the start vertex to 0
    // distances[startVertex] = 0;
    times[startVertex] = 0;

    // Add all the edges starting from the start vertex to the queue
    for (VehicleEdge edge in directedGraph.values) {
      queue.add(edge, edge.timeFromNow.toDouble());
    }

    while (queue.isEmpty == false) {
      // Select the next vertex to visit based on the distance from the start vertex
      VehicleEdge edge = queue.pop().value;

      // If the selected vertex has not been visited yet
      double previousTime = times[edge.fromVertex] ?? 0;

      double currentTime = edge.timeToNextStop.toDouble();

      double totalCurrentTime = previousTime + currentTime;
      
      double nextCurrentTime = times[edge.toVertex] ?? double.infinity;

      bool firstVisit = times[edge.toVertex] == null;
      
      if ((firstVisit || nextCurrentTime > totalCurrentTime) && previousTime <= totalCurrentTime) {
        
        // Update the distance from the start vertex for the selected vertex
        times[edge.toVertex] = totalCurrentTime;
        times[edge.toVertex] = previousTime + edge.timeToNextStop;

        // Update the previous vertex for the selected vertex
        previous[edge.toVertex] = edge;
      }
    }
    
    if (times[endVertex] == null) {
      throw Exception('Cannot find path from ${startVertex.id} to ${endVertex.id}');
    }

    // List to store the vertices in the shortest path
    List<VehicleEdge> path = <VehicleEdge>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list
    VehicleEdge? currentEdge;
    StopVertex currentVertex = endVertex;
    while (currentVertex != startVertex) {
      if (currentEdge != null) {
        path.add(currentEdge);
      }
      currentEdge = previous[currentVertex]!;
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
