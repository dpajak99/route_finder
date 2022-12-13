// import 'package:equatable/equatable.dart';
// import 'package:path_finder/models/endpoint_pair.dart';
// import 'package:path_finder/models/geo_node.dart';
//
// class ValueGraph<N extends Equatable, V extends num> {
//   final Set<N> nodes = {};
//   final Set<EndpointPair<N, V>> edges = <EndpointPair<N, V>>{};
//
//   Map<String, N> get nodesMap {
//     Map<String, N> nodesMap = {};
//     for (N node in nodes) {
//       nodesMap[(node as GeoNode).id] = node;
//     }
//     return nodesMap;
//   }
//  
//   void addNode(N node) {
//     nodes.add(node);
//   }
//  
//   void addNodes(Iterable<N> nodes) {
//     this.nodes.addAll(nodes);
//   }
//
//   void putEdgeValue(N startNode, N endNode, V value) {
//     edges.add(EndpointPair(startNode: startNode, endNode: endNode, value: value));
//     nodes.add(startNode);
//     nodes.add(endNode);
//   }
//
//   V edgeValue(N startNode, N endNode) {
//     EndpointPair<N, V> endpointPair = edges.firstWhere((EndpointPair<N, V> edge) => edge.startNode == startNode && edge.endNode == endNode);
//     return endpointPair.value;
//   }
//
//   Set<N> adjacentNodes(N node) {
//     Set<N> adjacentNodes = {};
//     for (EndpointPair<N, V> edge in edges) {
//       if (edge.startNode == node) {
//         adjacentNodes.add(edge.endNode);
//       }
//     }
//     return adjacentNodes;
//   }
// }
