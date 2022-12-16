import 'dart:math';

import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/models/cost_table.dart';
import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/vertex/geo_vertex.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdge extends TransitEdge {
  final String trackId;
  final int _departureTime;
  final int timeFromNow;
  final int timeToNextStop;
  final double distance;

  VehicleEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.trackId,
    required int departureTime,
    required this.timeFromNow,
    required this.timeToNextStop,
  })  : distance = Haversine.calcDistanceInMeters(sourceVertex, targetVertex),
        _departureTime = departureTime,
        super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );

  @override
  int get departureTime => _departureTime;
  
  @override
  int get arrivalTime => departureTime + timeToNextStop;
  
  
  
  @override
  double get distanceTime => timeToNextStop.toDouble();

  @override
  CostTable getCostTable(TransitEdge? previousEdge, double currentTotalTime) {
    double waitingTime = _calcWaitingTime(currentTotalTime);
    return RideCostTable(
      distanceToRide: distance,
      transferTime: waitingTime + distanceTime,
      waitingTime: _calcWaitingTime(currentTotalTime),
      transfer: previousEdge is VehicleEdge && trackId != previousEdge.trackId,
    );
  }
  
  @override
  bool isTransitAvailable(TransitEdge? previousEdge, double currentTotalTime) {
    double waitingTime = _calcWaitingTime(currentTotalTime);
    if( currentTotalTime != 0 && waitingTime <= 0 ) {
      return false;
    }
    return true;
  }

  double _calcWaitingTime(double currentTotalTime) {
    return timeFromNow.toDouble() - currentTotalTime;
  }

  ////////////////////
  double calcFromStart(StopVertex stopVertex) {
    return euclideanDistance(stopVertex);
  }

  double euclideanDistance(StopVertex from) {
    return sqrt(pow(from.lat - targetVertex.lat, 2) + pow(from.long - targetVertex.long, 2));
  }

  String getTimeAsString() {
    int fullTimeMinutes = departureTime;
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
