import 'dart:math';

import 'package:latlong2/latlong.dart' as map;
import 'package:path_finder/utils/models/distance.dart';

class Haversine {
  static const double earthRadius = 6371e3; //  Earth's radius in meters
  
  /// Haversine formula
  /// a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
  /// c = 2 ⋅ atan2( √a, √(1−a) )
  /// d = R ⋅ c
  /// Source: https://www.movable-type.co.uk/scripts/latlong.html
  static Distance calcDistance(map.LatLng sourceLatLng, map.LatLng targetLatLng) {
    // Convert latitude and longitude to radians
    final double sourceLatRad = radians(sourceLatLng.latitude);
    final double sourceLngRad = radians(sourceLatLng.longitude);
    final double targetLatRad = radians(targetLatLng.latitude);
    final double targetLngRad = radians(targetLatLng.longitude);

    // Calculate the differences between the two points' latitudes and longitudes
    final double latDiff = targetLatRad - sourceLatRad;
    final double lngDiff = targetLngRad - sourceLngRad;

    // Use the Haversine formula to calculate the distance
    final double a = pow(sin(latDiff / 2), 2) +
        cos(sourceLatRad) * cos(targetLatRad) * pow(sin(lngDiff / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return Distance(meters: double.parse(distance.toStringAsFixed(1)));
  }
  
  static map.LatLng findLatLngInDistance(map.LatLng startPoint, Distance distance, int bearing) {
    double lat2 = double.parse(computeDestinationLatitude(startPoint, distance, bearing).toStringAsFixed(6));
    double lon2 = double.parse(computeDestinationLongitude(startPoint, lat2, distance, bearing).toStringAsFixed(6));
    return map.LatLng(lat2, lon2);
  }

  static double computeDestinationLatitude(map.LatLng startPoint, Distance distance, num bearing) {
    double lat1Rad = radians(startPoint.latitude);
    double bearingRad = radians(bearing);

    double lat2Rad = asin(sin(lat1Rad) * cos(distance.inMeters / earthRadius) +
        cos(lat1Rad) * sin(distance.inMeters / earthRadius) * cos(bearingRad));

    return degrees(lat2Rad);
  }

  static double computeDestinationLongitude(map.LatLng startPoint, double lat2, Distance distance, num bearing) {
    double lat1Rad = radians(startPoint.latitude);
    double lon1Rad = radians(startPoint.longitude);
    double lat2Rad = radians(lat2);
    double bearingRad = radians(bearing);

    double lon2Rad = lon1Rad + atan2(
        sin(bearingRad) * sin(distance.inMeters / earthRadius) * cos(lat1Rad),
        cos(distance.inMeters / earthRadius) - sin(lat1Rad) * sin(lat2Rad));

    return degrees(lon2Rad);
  }

  static double radians(num deg) => deg * (pi / 180);

  static double degrees(num rad) => rad * (180 / pi);
}