// import 'dart:collection';
//
// import 'package:path_finder/models/a_star_node_wrapper.dart';
// import 'package:path_finder/models/geo_node.dart';
// import 'package:path_finder/models/geo_node_heuristic.dart';
// import 'package:path_finder/models/value_graph.dart';
//
// class AStar {
//   List<AStarNodeWrapper>? solve({required ValueGraph<GeoNode, double> graph, required GeoNode source, required GeoNode target}) {
//     AStarNodeWrapper startNode = AStarNodeWrapper(geoNode: source, h: 0, f: 0, g: 0);
//     AStarNodeWrapper targetNode = AStarNodeWrapper(geoNode: target, h: 0, f: 0, g: 0);
//    
//     List<AStarNodeWrapper> openList = <AStarNodeWrapper>[startNode];
//     List<AStarNodeWrapper> closedList = <AStarNodeWrapper>[];
//    
//     while(openList.isNotEmpty) {
//       print('openList: ${openList.length}');
//       AStarNodeWrapper currentNode = openList.first;
//       int currentIndex = 0;
//       for (int i = 0; i < openList.length; i++) {
//         if (openList[i].f < currentNode.f) {
//           currentNode = openList[i];
//           currentIndex = i;
//         }
//       }
//      
//       openList.removeAt(currentIndex);
//       closedList.add(currentNode);
//      
//       if (currentNode.geoNode == targetNode.geoNode) {
//         List<AStarNodeWrapper> path = <AStarNodeWrapper>[];
//         AStarNodeWrapper current = currentNode;
//         while (current.geoNode != startNode.geoNode) {
//           path.add(current);
//           current = current.parent!;
//         }
//         path.add(startNode);
//         path = path.reversed.toList();
//         return path;
//       }
//      
//       List<AStarNodeWrapper> children = <AStarNodeWrapper>[];
//       for (GeoNode geoNode in graph.adjacentNodes(currentNode.geoNode)) {
//         AStarNodeWrapper child = AStarNodeWrapper(geoNode: geoNode, parent: currentNode, h: 0, f: 0, g: 0);
//         children.add(child);
//       }
//      
//       for (AStarNodeWrapper child in children) {
//         for (AStarNodeWrapper closedNode in closedList) {
//           if (child.geoNode == closedNode.geoNode) {
//             continue;
//           }
//         }
//        
//         child.g = currentNode.g + graph.edgeValue(currentNode.geoNode, child.geoNode);
//         child.h = GeoNodeHeuristic.calculateEuclideanDistance(startNode.geoNode, child.geoNode);
//         child.f = child.g + child.h;
//        
//         for (AStarNodeWrapper openNode in openList) {
//           if (child.geoNode == openNode.geoNode && child.g > openNode.g) {
//             continue;
//           }
//         }
//        
//         openList.add(child);
//       }
//     }
//    
//     print('No path found');
//     return null;
//   }
// }
