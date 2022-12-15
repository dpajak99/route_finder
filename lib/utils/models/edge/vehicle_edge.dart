import 'dart:math';

import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/vertex/geo_vertex.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdge extends TransitEdge {
  final String trackId;
  final int timeInMin;
  final int timeFromNow;
  final int timeToNextStop;
  
  const VehicleEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.trackId,
    required this.timeInMin,
    required this.timeFromNow,
    required this.timeToNextStop,
  }) : super(
    sourceVertex: sourceVertex,
    targetVertex: targetVertex,
  );
  
  @override
  double calcCostToReachNeighbor(double currentTotalTime) {
    return timeFromNow.toDouble() - currentTotalTime;
  }
  
  double calcCost() {
    return euclideanDistance(sourceVertex) + timeToNextStop;
  }
  
  double calcFromStart(StopVertex stopVertex) {
    return euclideanDistance(stopVertex);
  }
  
  double euclideanDistance(StopVertex from) {
    return sqrt(pow(from.lat - targetVertex.lat, 2) + pow(from.long - targetVertex.long, 2));
  }
  
  String getTimeAsString() {
    int fullTimeMinutes = timeInMin;
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
  List<Object?> get props => <Object?>[sourceVertex, targetVertex, trackId, timeFromNow, timeToNextStop];
  
  @override
  String toString() {
    return 'BUS: From: ${sourceVertex.name}, To: ${targetVertex.name}, Time: ${getTimeAsString()}, Time from now: ${getTimeFromNowAsString()} Track: $trackId';
  }
}
