import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class Haversine {
  /// Haversine formula
  /// a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
  /// c = 2 ⋅ atan2( √a, √(1−a) )
  /// d = R ⋅ c
  /// Source: https://www.movable-type.co.uk/scripts/latlong.html
  static double calcDistanceInMeters(LatLng sourceLatLng, LatLng targetLatLng) {
    const double earthRadius = 6371e3; // Earth's radius in meters

    // Convert latitude and longitude to radians
    final double sourceLatRad = sourceLatLng.latitude * pi / 180;
    final double sourceLngRad = sourceLatLng.longitude * pi / 180;
    final double targetLatRad = targetLatLng.latitude * pi / 180;
    final double targetLngRad = targetLatLng.longitude * pi / 180;

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