import 'dart:math';

import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdge extends Edge {
  static const int currentTimeMock = 840;
  final StopVertex fromVertex;
  final StopVertex toVertex;
  final String trackId;
  final int timeFromNow;
  final int timeToNextStop;
  
  const VehicleEdge({
    required this.fromVertex,
    required this.toVertex,
    required this.trackId,
    required this.timeFromNow,
    required this.timeToNextStop,
  }) : super();
  
  double calcCost() {
    return euclideanDistance(fromVertex) + timeToNextStop;
  }
  
  double calcFromStart(StopVertex stopVertex) {
    return euclideanDistance(stopVertex);
  }
  
  double euclideanDistance(StopVertex from) {
    return sqrt(pow(from.lat - toVertex.lat, 2) + pow(from.long - toVertex.long, 2));
  }
  
  String getTimeAsString() {
    int fullTimeMinutes = currentTimeMock + timeFromNow;
    int hours = fullTimeMinutes ~/ 60;
    int minutes = fullTimeMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  
  String getTimeFromNowAsString() {
    int hours = timeFromNow ~/ 60;
    int minutes = timeFromNow % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  
  @override
  List<Object?> get props => <Object?>[fromVertex, toVertex, trackId, timeFromNow, timeToNextStop];
  
  @override
  String toString() {
    return 'From: ${fromVertex.name}, To: ${toVertex.name}, Time: ${getTimeAsString()}, Time from now: ${getTimeFromNowAsString()} Track: $trackId';
  }
}
