import 'package:path_finder/infra/entity/vehicle_edge_entity.dart';
import 'package:path_finder/utils/models/distance.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/utils/time_utils.dart';

class VehicleEdge extends TransitEdge {
  final String trackId;
  final String name;
  final int departureTime;
  final int _timeFromNow;
  final int _timeToNextStop;

  VehicleEdge({
    required this.trackId,
    required this.name,
    required this.departureTime,
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required int timeFromNow,
    required int timeToNextStop,
    required int distanceInMeters,
    required List<String> polylines,
  })  : _timeFromNow = timeFromNow,
        _timeToNextStop = timeToNextStop,
        super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
          distance: Distance( meters: distanceInMeters),
          polylines: polylines,
        );

  factory VehicleEdge.fromEntity(VehicleEdgeEntity vehicleEdgeEntity, StopVertex sourceVertex, StopVertex targetVertex, int timeFromNow) {
    return VehicleEdge(
      sourceVertex: sourceVertex,
      targetVertex: targetVertex,
      departureTime: vehicleEdgeEntity.departureTimeInMin,
      trackId: vehicleEdgeEntity.trackId,
      name: vehicleEdgeEntity.busName,
      timeFromNow: timeFromNow,
      timeToNextStop: vehicleEdgeEntity.timeToNextStopInMin,
      distanceInMeters: vehicleEdgeEntity.distanceInMeters,
      polylines: vehicleEdgeEntity.polylines,
    );
  }

  @override
  double get transitStartTime => _timeFromNow.toDouble();

  @override
  TransitEdgeTime calcTime(AlgorithmSearchState transitSearchPosition) {
    if (transitSearchPosition.isFirstEdge) {
      return TransitEdgeTime(
        waitingTime: _timeFromNow.toDouble(),
        transitTime: _timeToNextStop,
      );
    }
    double waitingTime = _timeFromNow - transitSearchPosition.totalTimeFromStart;
    return TransitEdgeTime(transitTime: _timeToNextStop, waitingTime: waitingTime);
  }

  @override
  double calcCost(AlgorithmSearchState transitSearchPosition) {
    TransitEdge? previousTransitEdge = transitSearchPosition.previousEdge?.transitEdge;

    TransitEdgeTime fullEdgeTime = calcTime(transitSearchPosition);
    bool isTransfer = previousTransitEdge is VehicleEdge && trackId != previousTransitEdge.trackId;

    double specificEdgeCost = transitSearchPosition.vehicleEdgeCostTable.calcCost(
      fullEdgeTime: fullEdgeTime,
      isTransfer: isTransfer,
    );

    double totalCost = specificEdgeCost;
    return totalCost;
  }

  @override
  bool canReachEdge(AlgorithmSearchState transitSearchPosition) {
    if (transitSearchPosition.isFirstEdge) {
      return true;
    }
    TransitEdge? previousTransitEdge = transitSearchPosition.previousEdge?.transitEdge;
    bool isTransfer = previousTransitEdge is VehicleEdge && trackId != previousTransitEdge.trackId;
    int timeFromNow = _timeFromNow;
    if (isTransfer) {
      timeFromNow += 4;
    }

    return transitSearchPosition.previousEdge!.edgeTimeEnd <= timeFromNow;
  }
  
  @override
  String toString() {
    return 'BUS: From: ${sourceVertex.name}, To: ${targetVertex.name}, Time from now: ${TimeUtils.minutesToString(_timeFromNow)} Track: $trackId';
  }

  @override
  List<Object?> get props => <Object?>[sourceVertex, targetVertex, trackId, _timeFromNow, _timeToNextStop];
}
