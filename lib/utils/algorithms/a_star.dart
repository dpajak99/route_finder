import 'dart:collection';

import 'package:path_finder/utils/models/directed_graph.dart';
import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/vertex/geo_vertex.dart';

class AStar {
  // In the A* algorithm, the f value is a combination of the g value and the h value.
  // The g value represents the cost of the path from the starting point to the current point,
  // while the h value is an estimate of the cost of the cheapest path from the current point to the goal.
  // The f value is the sum of the g and h values, and it represents an estimate of the total cost
  // of the cheapest path from the start to the goal through the current point.
  // The A* algorithm uses the f value to determine the next best point to move to in order
  // to reach the goal. It will always choose the point with the lowest f value.
  static List<GeoVertex> findShortestPath(DirectedGraph directedGraph, GeoVertex start, GeoVertex end) {
    // Set of visited vertices to avoid revisiting them
    Set<GeoVertex> visited = <GeoVertex>{};

    // Priority queue to select the next vertex to visit
    // based on the distance from the start vertex
    Queue<VehicleEdge> queue = Queue<VehicleEdge>();

    // Map to store the previous vertex for each vertex
    // in the shortest path from the start vertex
    Map<GeoVertex, GeoVertex> previous = <GeoVertex, GeoVertex>{};

    // Map to store the distance from the start vertex for each vertex
    Map<GeoVertex, int> distances = <GeoVertex, int>{};

    // Set the initial distance for the start vertex to 0
    distances[start] = 0;

    // Add all the edges starting from the start vertex to the queue
    for (VehicleEdge edge in directedGraph.values) {
      queue.add(edge);
    }

    while (queue.isNotEmpty) {
      // Select the next vertex to visit based on the distance from the start vertex
      VehicleEdge edge = queue.removeFirst();

      // If the selected vertex has not been visited yet
      if (!visited.contains(edge.toVertex)) {
        // Mark it as visited
        visited.add(edge.toVertex);

        // Update the distance from the start vertex for the selected vertex
        distances[edge.toVertex] = (distances[edge.fromVertex] ?? 0) + edge.timeFromNow;

        // Update the previous vertex for the selected vertex
        previous[edge.toVertex] = edge.fromVertex;
      }
    }

    // List to store the vertices in the shortest path
    List<GeoVertex> path = <GeoVertex>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list
    GeoVertex current = end;
    while (current != start) {
      path.add(current);
      current = previous[current]!;
    }

    // Add the start vertex to the beginning of the list
    path.insert(0, start);
    print(path);
    // Return the list of vertices in the shortest path
    return path;
  }

}
