import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';

class EdgeDetails {
  final TransitEdge transitEdge;
  final AlgorithmSearchState transitSearchPosition;
  final double cost;
  final TransitEdgeTime fullTime;
  final double timeFromStartToReachNeighbor;
  final double costFromStartToReachNeighbor;

  EdgeDetails._({
    required this.transitEdge,
    required this.transitSearchPosition,
    required this.cost,
    required this.fullTime,
    required this.timeFromStartToReachNeighbor,
    required this.costFromStartToReachNeighbor,
  });
  
  factory EdgeDetails.calcEdgeDetails({
    required TransitEdge neighborEdge,
    required AlgorithmSearchState transitSearchPosition,
    double heuristicCost = 0,
  }) {
    double cost = neighborEdge.calcCost(transitSearchPosition) + heuristicCost;
    TransitEdgeTime fullTime = neighborEdge.calcTime(transitSearchPosition);
    
    return EdgeDetails._(
      transitEdge: neighborEdge,
      transitSearchPosition: transitSearchPosition,
      cost: cost,
      fullTime: fullTime,
      timeFromStartToReachNeighbor: transitSearchPosition.totalTimeFromStart + fullTime.total,
      costFromStartToReachNeighbor: transitSearchPosition.totalCostFromStart + cost,
    );
  }

  double get edgeTime => edgeTimeEnd - edgeTimeStart;
  
  double get edgeTimeStart => transitSearchPosition.totalTimeFromStart;

  double get edgeTimeEnd => transitSearchPosition.totalTimeFromStart + fullTime.total;
  
  int get departureTime {
    if( transitEdge is VehicleEdge ) {
      return (transitEdge as VehicleEdge).departureTime;
    } else {
      return timeFromStartToReachNeighbor.toInt();
    }
  }

  @override
  String toString() {
    return '${transitEdge.runtimeType}\t\t ($cost) - start: ${parseMinToString(edgeTimeStart)}  | wait: ${fullTime.waitingTime}, | transit: ${fullTime.transitTime}, total ${parseMinToString(fullTime.total)}| end ${parseMinToString(edgeTimeEnd)}';
  }

  String parseMinToString(num min) {
    int hour = min ~/ 60;
    int minute = min.toInt() % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
