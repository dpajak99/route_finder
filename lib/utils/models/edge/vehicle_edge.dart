import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdge extends TransitEdge {
  final String trackId;
  final String busName;
  final int departureTime;
  final int _timeFromNow;
  final int _timeToNextStop;

  const VehicleEdge({
    required this.trackId,
    required this.busName,
    required this.departureTime,
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required int timeFromNow,
    required int timeToNextStop,
  })  : _timeFromNow = timeFromNow,
        _timeToNextStop = timeToNextStop, 
        super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );

  @override
  double get transitStartTime => _timeFromNow.toDouble();
  
  @override
  FullEdgeTime calcTime(TransitSearchPosition transitSearchPosition) {
    if( transitSearchPosition.isFirstEdge ) {
      return FullEdgeTime(
        waitingTime: _timeFromNow.toDouble(),
        transitTime: _timeToNextStop.toDouble(),
      );
    }
    double waitingTime = _timeFromNow - transitSearchPosition.totalTimeFromStart;
    return FullEdgeTime(transitTime: _timeToNextStop.toDouble(), waitingTime: waitingTime);
  }
  
  @override
  double calcCost(TransitSearchPosition transitSearchPosition) {
    TransitEdge? previousTransitEdge = transitSearchPosition.previousEdge?.transitEdge;

    FullEdgeTime fullEdgeTime = calcTime(transitSearchPosition);
    bool isTransfer = previousTransitEdge is VehicleEdge && trackId != previousTransitEdge.trackId;

    double specificEdgeCost = transitSearchPosition.vehicleEdgeCostTable.calcCost(
      fullEdgeTime: fullEdgeTime,
      isTransfer: isTransfer,
    );
  
    double totalCost = specificEdgeCost;
    return totalCost;
  }

  @override
  bool canReachEdge(TransitSearchPosition transitSearchPosition) {
    if (transitSearchPosition.isFirstEdge) {
      return true;
    }
    TransitEdge? previousTransitEdge = transitSearchPosition.previousEdge?.transitEdge;
    bool isTransfer = previousTransitEdge is VehicleEdge && trackId != previousTransitEdge.trackId;
    int timeFromNow = _timeFromNow;
    if(isTransfer) {
      timeFromNow += 4;
    }
    
    return transitSearchPosition.previousEdge!.edgeTimeEnd <= timeFromNow;
  }
  

  String getTimeAsString(int time) {
    int fullTimeMinutes = time;
    int hours = fullTimeMinutes ~/ 60;
    int minutes = fullTimeMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  
  @override
  String toString() {
    return 'BUS: From: ${sourceVertex.name}, To: ${targetVertex.name}, Time from now: ${getTimeAsString(_timeFromNow)} Track: $trackId';
  }

  @override
  List<Object?> get props => <Object?>[sourceVertex, targetVertex, trackId, _timeFromNow, _timeToNextStop];

}
