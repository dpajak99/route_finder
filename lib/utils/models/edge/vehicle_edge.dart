import 'package:path_finder/config/locator.dart';
import 'package:path_finder/listeners/edge_cost_config/edge_cost_config.dart';
import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdge extends TransitEdge {
  final String _trackId;
  final int _timeFromNow;
  final int _timeToNextStop;
  final double _distance;

  VehicleEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required String trackId,
    required int timeFromNow,
    required int timeToNextStop,
  })  : _distance = Haversine.calcDistanceInMeters(sourceVertex, targetVertex),
        _trackId = trackId,
        _timeFromNow = timeFromNow,
        _timeToNextStop = timeToNextStop, 
        super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );

  @override
  double get transitStartTime => _timeFromNow.toDouble();
  
  @override
  FullEdgeTime calcTime(TransitSearchPosition transitSearchPosition) {
    double waitingTime = _timeFromNow - transitSearchPosition.totalTimeFromStart;
    return FullEdgeTime(transitTime: _timeToNextStop.toDouble(), waitingTime: waitingTime);
  }
  
  @override
  double calcCost(TransitSearchPosition transitSearchPosition) {
    EdgeCostConfig edgeCostConfig = getIt<EdgeCostConfig>();
    TransitEdge? previousTransitEdge = transitSearchPosition.previousTransitEdgeResult?.transitEdge;

    FullEdgeTime fullEdgeTime = calcTime(transitSearchPosition);
    bool isTransfer = previousTransitEdge is VehicleEdge && _trackId != previousTransitEdge._trackId;

    double specificEdgeCost = edgeCostConfig.vehicleEdgeCostTable.calcCost(
      fullEdgeTime: fullEdgeTime,
      isTransfer: isTransfer,
    );
    // double globalEdgeCost = edgeCostConfig.transitEdgeCostTable.calcCost(fullEdgeTime.total, _distance);
  
    double totalCost = specificEdgeCost;
    return totalCost;
  }

  @override
  bool canReachEdge(TransitSearchPosition transitSearchPosition) {
    if (transitSearchPosition.isFirstEdge) {
      return true;
    }
    return transitSearchPosition.previousTransitEdgeResult!.edgeTimeEnd <= _timeFromNow;
  }
  

  String getTimeAsString(int time) {
    int fullTimeMinutes = time;
    int hours = fullTimeMinutes ~/ 60;
    int minutes = fullTimeMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  
  @override
  String toString() {
    return 'BUS: From: ${sourceVertex.name}, To: ${targetVertex.name}, Time from now: ${getTimeAsString(_timeFromNow)} Track: $_trackId';
  }

  @override
  List<Object?> get props => <Object?>[sourceVertex, targetVertex, _trackId, _timeFromNow, _timeToNextStop];

}
