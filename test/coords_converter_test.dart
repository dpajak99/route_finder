import 'dart:math';

import 'package:path_finder/utils/coords_converter.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

void main() {
  StopVertex source = const StopVertex(id: '808', lat: 50.06298, long: 21.13722, name: 'Jodłówka - Wałki - Las 11');
  StopVertex target = const StopVertex(id: '807', lat: 50.06349, long: 21.1368, name: 'Jodłówka - Wałki - Las 36');

}

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
