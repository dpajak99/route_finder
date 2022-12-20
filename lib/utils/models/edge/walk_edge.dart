import 'package:path_finder/utils/models/cost_table.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdge extends TransitEdge {
  static const int averageWalkingSpeedMeterPerMinute = 50;
  
  final double distanceToWalk;
  final int _fullTransitTime;

  const WalkEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.distanceToWalk,
  })  : _fullTransitTime = distanceToWalk ~/ averageWalkingSpeedMeterPerMinute,
        super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );

  @override
  FullEdgeTime calcFullEdgeTime(int currentTotalTime) {
    return FullEdgeTime( waitingTime: 0, transitTime: _fullTransitTime);
  }

  @override
  CostTable buildCostTable(TransitEdge? previousEdge, int currentTotalTime) {
    return WalkCostTable(distanceToWalk: distanceToWalk, walkingTime: _fullTransitTime);
  }
  
  @override
  bool isTransitAvailable(TransitEdgeResult? previousEdgeResult, int currentTotalTime) {
    if( previousEdgeResult == null ) {
      return true;
    }
    bool nextWalkEdgeInLine = previousEdgeResult.transitEdge is WalkEdge;
    return nextWalkEdgeInLine == false && previousEdgeResult.edgeTimeEnd <= currentTotalTime;
  }
  
  
  @override
  String toString() {
    return 'WALK: ${sourceVertex.name} -> ${targetVertex.name} (${distanceToWalk.toStringAsFixed(2)}m) ${_fullTransitTime.toStringAsFixed(2)}min';
  }
}
