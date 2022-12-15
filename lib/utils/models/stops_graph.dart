import 'dart:math';

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
            distanceToWalk: calcDistanceInMeters(sourceVertex, targetVertex),
          );

          if (walkEdge.distanceToWalk < maxWalkingDistanceInMeters) {
            walkEdges.add(walkEdge);
          }
        }
      }
    }
    addEdgeIterable(walkEdges);
  }

  // Haversine formula
  // a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
  // c = 2 ⋅ atan2( √a, √(1−a) )
  // d = R ⋅ c
  // https://www.movable-type.co.uk/scripts/latlong.html
  // double calcDistanceInMeters(StopVertex sourceVertex, StopVertex targetVertex) {
  //   double averageRadiusOfEarthInMeters = 6371000;
  //
  //   double lat1 = sourceVertex.lat;
  //   double lat2 = targetVertex.lat;
  //   double lon1 = sourceVertex.long;
  //   double lon2 = targetVertex.long;
  //
  //   double phi1 = lat1 * pi/180; // φ, λ in radians
  //   double phi2 = lat2 * pi/180;
  //   double deltaPhi = (lat2-lat1) * pi/180;
  //   double deltaLambda = (lon2-lon1) * pi/180;
  //
  //   double a = sin(deltaPhi/2) * sin(deltaPhi/2) +
  //   cos(phi1) * cos(phi2) *
  //   sin(deltaLambda/2) * sin(deltaLambda/2);
  //   double c = 2 * atan2(sqrt(a), sqrt(1-a));
  //
  //   double d = averageRadiusOfEarthInMeters * c;
  //   return d;
  // }

  double calcDistanceInMeters(StopVertex sourceVertex, StopVertex targetVertex) {
    const double earthRadius = 6371e3; // Earth's radius in meters

    // Convert latitude and longitude to radians
    final double sourceLatRad = sourceVertex.lat * pi / 180;
    final double sourceLngRad = sourceVertex.long * pi / 180;
    final double targetLatRad = targetVertex.lat * pi / 180;
    final double targetLngRad = targetVertex.long * pi / 180;

    // Calculate the differences between the two points' latitudes and longitudes
    final double latDiff = targetLatRad - sourceLatRad;
    final double lngDiff = targetLngRad - sourceLngRad;

    // Use the Haversine formula to calculate the distance
    final double a = pow(sin(latDiff / 2), 2) +
        cos(sourceLatRad) * cos(targetLatRad) * pow(sin(lngDiff / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance;
  }
}
