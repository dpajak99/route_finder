// import 'package:path_finder/utils/models/graph/stops_graph.dart';
// import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
// import 'package:path_finder/utils/models/vertex/vertex.dart';
// import 'package:path_finder/utils/transit_search_request.dart';
//
// // algorytm genetychny
// // https://www.youtube.com/watch?v=9zfeTw-uFCw
//
// // algorytm Floyda-Warshalla
// class BellmanFord {
//   Map<Vertex, num>? bellmanFord(StopsGraph graph, StopVertex source) {
//     Map<StopVertex, num> distances = <StopVertex, num>{};
//     distances[source] = 0;
//
//     var edges = graph.edges;
//     var counter = graph.numberOfVertices - 1;
//
//     bool shouldUpdate(Vertex u, Vertex v, num w) {
//       if (!distances.containsKey(u)) return false;
//       var uValue = distances[u]!;
//       var vValue = distances[v] ?? (uValue + w + 1);
//
//       return uValue + w < vValue;
//     }
//
//     while (counter > 0) {
//       for (var edge in edges) {
//         var u = edge[0];
//         var v = edge[1];
//         var w = edge[2];
//         if (shouldUpdate(u, v, w)) {
//           distances[v] = distances[u]! + w;
//         }
//       }
//
//       counter--;
//     }
//
//     for (var edge in edges) {
//       var u = edge[0];
//       var v = edge[1];
//       var w = edge[2];
//       if (shouldUpdate(u, v, w)) {
//         return null;
//       }
//     }
//
//     return distances;
//   }
// }