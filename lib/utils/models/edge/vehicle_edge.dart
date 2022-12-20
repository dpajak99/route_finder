import 'dart:math';

import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/models/cost_table.dart';
import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_result.dart';
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
  CostTable buildCostTable(TransitEdge? previousEdge, int currentTotalTime) {
    int waitTime = calcWaitingTime(currentTotalTime);
    return RideCostTable(
      distanceToRide: distance,
      vehicleTime: timeToNextStop,
      waitTime: waitTime,
      transfer: previousEdge is VehicleEdge && trackId != previousEdge.trackId,
    );
  }
  
  @override
  FullEdgeTime calcFullEdgeTime(int currentTotalTime) {
    int waitingTime = calcWaitingTime(currentTotalTime);
    return FullEdgeTime( transitTime: timeToNextStop, waitingTime: waitingTime);
    
  }
  
  @override
  bool isTransitAvailable(TransitEdgeResult? previousEdgeResult, int currentTotalTime) {
    if(previousEdgeResult == null ) {
      return true;
    }
    return previousEdgeResult.edgeTimeEnd <= timeFromNow;
  }
  
  int calcWaitingTime(int currentTotalTime) {
    return timeFromNow - currentTotalTime;
  }

  ////////////////////
  int calcFromStart(StopVertex stopVertex) {
    return euclideanDistance(stopVertex).toInt();
  }

  double euclideanDistance(StopVertex from) {
    return sqrt(pow(from.lat - targetVertex.lat, 2) + pow(from.long - targetVertex.long, 2));
  }

  String getTimeAsString() {
    int fullTimeMinutes = _departureTime;
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
