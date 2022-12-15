import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/models/directed_graph.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopsGraph extends DirectedGraph<StopVertex, TransitEdge> {
  static const double maxWalkingDistanceInMeters = 3000;

  void addStops(List<StopVertex> stops) {
    addVertexIterable(stops);
    _addWalkEdges(stops);
  }

  void _addWalkEdges(List<StopVertex> stops) {
    List<WalkEdge> walkEdges = List<WalkEdge>.empty(growable: true);

    for (StopVertex sourceVertex in stops) {
      for (StopVertex targetVertex in stops) {
        if (sourceVertex != targetVertex) {
          WalkEdge walkEdge = WalkEdge(
            sourceVertex: sourceVertex,
            targetVertex: targetVertex,
            distanceToWalk: Haversine.calcDistanceInMeters(sourceVertex, targetVertex),
          );

          if (walkEdge.distanceToWalk < maxWalkingDistanceInMeters) {
            walkEdges.add(walkEdge);
          }
        }
      }
    }
    addEdgeIterable(walkEdges);
  }
}
