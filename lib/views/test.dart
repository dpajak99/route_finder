// //Sure, here is an example of how you could create a graph from schedule data and find paths between locations using the Dart programming language:
//
// // Copy code
// // Define a class to represent a vertex in the graph
// import 'package:equatable/equatable.dart';
//
// class Vertex extends Equatable {
//   final String location;
//   final double lat;
//   final double lng;
//
//   const Vertex(this.location, this.lat, this.lng);
//  
//   @override
//   List<Object?> get props => [location, lat, lng];
// }
//
// // Define a class to represent an edge in the graph
// class Edge extends Equatable {
//   final Vertex start;
//   final Vertex end;
//   final String means;
//   final List<DateTime> times;
//
//   const Edge(this.start, this.end, this.means, this.times);
//
//   @override
//   List<Object?> get props => [start, end, means, times];
// }
//
// // Dijkstra
// void main() {
// // Create a new graph
//   Map<Vertex, List<Edge>> graph = {};
//
// // Add vertices to the graph
//   graph[const Vertex("A", 51.5074, 0.1278)] = [];
//   graph[const Vertex("B", 51.5055, 0.0769)] = [];
//
// // Add edges to the graph
//   graph[const Vertex("A", 51.5074, 0.1278)]
//       ?.add(Edge(const Vertex("A", 51.5074, 0.1278), const Vertex("B", 51.5055, 0.0769), "bus", [DateTime(2022, 12, 8, 10, 0), DateTime(2022, 12, 8, 12, 0)]));
//
// // Use Dijkstra's algorithm to find the shortest path between two locations
//   Map<Vertex, num> distances = {};
//   Map<Vertex, Vertex> previous = {};
//
//   List<Vertex> unvisited = graph.keys.toList();
//
//   distances[const Vertex("A", 51.5074, 0.1278)] = 0;
//
//   while (unvisited.isNotEmpty) {
// // Find the unvisited vertex with the smallest distance
//     Vertex? smallest;
//     for (Vertex vertex in unvisited) {
//       print('start ${distances[vertex]}');
//       if (smallest == null || (distances[vertex] ?? 0) < (distances[smallest] ?? 0)) {
//         smallest = vertex;
//       }
//       print('end ${distances[vertex]}');
//     }
//
//     if (smallest == null) {
//       break;
//     }
//
//     unvisited.remove(smallest);
//
// // Update the distances to the neighboring vertices
//     for (Edge edge in graph[smallest]!) {
//       Vertex neighbor = edge.end;
//       num distance = distances[smallest]! + edge.times.length; // Use the number of connections as the distance
//
//       if (distance < (distances[neighbor] ?? 0) || !distances.containsKey(neighbor)) {
//       if (distance < (distances[neighbor] ?? 0) || !distances.containsKey(neighbor)) {
//         distances[neighbor] = distance;
//         previous[neighbor] = smallest;
//       }
//     }
//   }
//
// // Construct the path from the start to the end location
//   List<Vertex> path = [];
//   Vertex? current = const Vertex("B", 51.5055, 0.0769);
//
//   while (current != null) {
//     path.add(current);
//     current = previous[current];
//   }
//
// // Print the path to the console
//   for (Vertex vertex in path.reversed) {
//     print(vertex.location);
//   }
// }
// //
// // // A*
// // void main() {
// //   // Create a new graph
// //   List<List<Edge>> graph = [];
// //
// // // Add vertices to the graph
// //   graph.add([]); // Vertex "A"
// //   graph.add([]); // Vertex "B"
// //
// // // Add edges to the graph
// //   graph[0].add(Edge(Vertex("A", 51.5074, 0.1278), Vertex("B", 51.5055, 0.0769), "bus", [DateTime(2022, 12, 8, 10, 0), DateTime(2022, 12, 8, 12, 0)]));
// //
// // // Use A* search to find the shortest path between two locations
// //   Map<Vertex, num> distances = {};
// //   Map<Vertex, Vertex> previous = {};
// //
// //   List<Vertex> unvisited = graph.keys.toList();
// //
// //   distances[Vertex("A", 51.5074, 0.1278)] = 0;
// //
// //   while (unvisited.isNotEmpty) {
// //     // Find the unvisited vertex with the smallest distance
// //     Vertex smallest = null;
// //     for (Vertex vertex in unvisited) {
// //       if (smallest == null || distances[vertex] < distances[smallest]) {
// //         smallest = vertex;
// //       }
// //     }
// //
// //     if (smallest == null) {
// //       break;
// //     }
// //
// //     unvisited.remove(smallest);
// //
// //     // Update the distances to the neighboring vertices
// //     for (int i = 0; i < graph[smallest].length; i++) {
// //       Edge edge = graph[smallest][i];
// //       Vertex neighbor = edge.end;
// //       num distance = distances[smallest] + edge.times.length; // Use the number of connections as the distance
// //
// //       if (distance < distances[neighbor] || !distances.containsKey(neighbor)) {
// //         distances[neighbor] = distance;
// //         previous[neighbor] = smallest;
// //       }
// //     }
// //   }
// //
// // // Construct the path from the start to the end location
// //   List<Vertex> path = [];
// //   Vertex current = Vertex("B", 51.5055, 0.0769);
// //
// //   while (current != null) {
// //     path.add(current);
// //     current = previous[current];
// //   }
// //
// // // Print the path to the console
// //   for (Vertex vertex in path.reversed) {
// //     print(vertex.location);
// //   }
// // }
// //
// //
// // // This implementation is similar to the previous examples, but it uses a Map to represent the graph instead of a List. This allows for faster lookup and insertion of vertices
// // void main() {
// //   // Create a new graph
// //   Map<Vertex, List<Edge>> graph = {};
// //
// // // Add vertices to the graph
// //   graph[Vertex("A", 51.5074, 0.1278)] = [];
// //   graph[Vertex("B", 51.5055, 0.0769)] = [];
// //
// // // Add edges to the graph
// //   graph[Vertex("A", 51.5074, 0.1278)].add(Edge(Vertex("A", 51.5074, 0.1278), Vertex("B", 51.5055, 0.0769), "bus", [DateTime(2022, 12, 8, 10, 0), DateTime(2022, 12, 8, 12, 0)]));
// //
// // // Use Dijkstra's algorithm to find the shortest path between two locations
// //   Map<Vertex, num> distances = {};
// //   Map<Vertex, Vertex> previous = {};
// //
// //   List<Vertex> unvisited = graph.keys.toList();
// //
// //   distances[Vertex("A", 51.5074, 0.1278)] = 0;
// //
// //   while (unvisited.isNotEmpty) {
// //     // Find the unvisited vertex with the smallest distance
// //     Vertex smallest = null;
// //     for (Vertex vertex in unvisited) {
// //       if (smallest == null || distances[vertex] < distances[smallest]) {
// //         smallest = vertex;
// //       }
// //     }
// //
// //     if (smallest == null) {
// //       break;
// //     }
// //
// //     unvisited.remove(smallest);
// //
// //     // Update the distances to the neighboring vertices
// //     for (Edge edge in graph[smallest]) {
// //       Vertex neighbor = edge.end;
// //       num distance = distances[smallest] + edge.times.length; // Use the number of connections as the distance
// //
// //       if (distance < distances[neighbor] || !distances.containsKey(neighbor)) {
// //         distances[neighbor] = distance;
// //         previous[neighbor] = smallest;
// //       }
// //     }
// //   }
// //
// // // Construct the path from the start to the end location
// //   List<Vertex> path = [];
// //   Vertex current = Vertex("B", 51.5055, 0.0769);
// //
// //   while (current != null) {
// //     path.add(current);
// //     current = previous[current];
// //   }
// //
// // // Print the path to the console
// //   for (Vertex vertex in path.reversed) {
// //     print(vertex.location);
// //   }
// // }
// //
// // // One possible way to improve the implementation is to add constraints to the search algorithm to take into account the preferences of potential passengers/customers. For example, you could add a constraint to only include connections that use a specific means of transportation, or to exclude connections that take longer than a specified maximum travel time.
// // // 
// // // Another way to improve the implementation is to use a more efficient algorithm for finding paths in the graph. For example, you could use the Johnson's algorithm to find the shortest paths between all pairs of vertices in the graph, or you could use the Bellman-Ford algorithm to find the shortest paths in a graph with negative edge weights.
// // // 
// // // Additionally, you could add additional information to the graph, such as the distances between vertices or the time it takes to travel along each edge. This can be useful for optimizing the search algorithm and finding the shortest paths in the graph. You could also use a more advanced data structure, such as a binary heap, to improve the performance of the search algorithm.
// // // 
// // // Finally, you could consider implementing the algorithm in a different programming language, such as C++ or Python, which may offer better performance and scalability for this type of problem.
// //
// //
// // void main() {
// //   // Create a new graph
// //   Map<Vertex, List<Edge>> graph = {};
// //
// // // Add vertices to the graph
// //   graph[Vertex("A", 51.5074, 0.1278)] = [];
// //   graph[Vertex("B", 51.5055, 0.0769)] = [];
// //   graph[Vertex("C", 51.5194, 0.1266)] = [];
// //   graph[Vertex("D", 51.4964, 0.1217)] = [];
// //   graph[Vertex("E", 51.4983, 0.0710)] = [];
// //   graph[Vertex("F", 51.5105, 0.1026)] = [];
// //   graph[Vertex("G", 51.5169, 0.0878)] = [];
// //   graph[Vertex("H", 51.4973, 0.0649)] = [];
// //   graph[Vertex("I", 51.4893, 0.1099)] = [];
// //   graph[Vertex("J", 51.5007, 0.1490)] = [];
// //   graph[Vertex("K", 51.5052, 0.0475)] = [];
// //   graph[Vertex("L", 51.5236, 0.0649)] = [];
// //   graph[Vertex("M", 51.5295, 0.1235)] = [];
// //   graph[Vertex("N", 51.5257, 0.0931)] = [];
// //   graph[Vertex("O", 51.5181, 0.0355)] = [];
// //   graph[Vertex("P", 51.5142, 0.0965)] = [];
// //   graph[Vertex("Q", 51.5085, 0.0359)] = [];
// //   graph[Vertex("R", 51.4933, 0.0796)] = [];
// //   graph[Vertex("S", 51.5062, 0.1426)] = [];
// //   graph[Vertex("T", 51.5202, 0.0694)] = [];
// //   graph[Vertex("U", 51.5041, 0.0412)] = [];
// //   graph[Vertex("V", 51.4877, 0.0519)] = [];
// //   graph[Vertex("W", 51.5103, 0.0819)] = [];
// //   graph[Vertex("X", 51.5128, 0.0581)] = [];
// //   graph[Vertex("Y", 51.5012, 0.0327)] = [];
// //   graph[Vertex("Z", 51.5199, 0.0689)] = [];
// //
// //   // Add edges to the graph
// //   graph[Vertex("A", 51.5074, 0.1278)].add(Edge(Vertex("A", 51.5074, 0.1278), Vertex("B", 51.5055, 0.0769), "bus", [DateTime(2022, 12, 8, 10, 0), DateTime(20
// // }



// void breadthFirstSearch(StopVertex startVertex, List<VehicleEdge> edges, Function(StopVertex) visit) {
//   // Create a queue for the BFS algorithm
//   var queue = Queue<StopVertex>();
//   // Create a set to keep track of visited vertices
//   var visited = Set<StopVertex>();
//
//   // Add the starting vertex to the queue and mark it as visited
//   queue.add(startVertex);
//   visited.add(startVertex);
//
//   // Loop through the queue while it is not empty
//   while (queue.isNotEmpty) {
//     // Get the next vertex in the queue
//     var currentVertex = queue.removeFirst();
//     // Visit the current vertex
//     visit(currentVertex);
//
//     // Loop through all the edges to find the neighbors of the current vertex
//     for (var edge in edges) {
//       var fromVertex = edge.fromVertex;
//       var toVertex = edge.toVertex;
//       if (fromVertex == currentVertex && !visited.contains(toVertex)) {
//         // Add the neighbor to the queue and mark it as visited
//         queue.add(toVertex);
//         visited.add(toVertex);
//       }
//     }
//   }
// }

