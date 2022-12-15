import 'dart:math';

import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdge extends TransitEdge {
  final double transferPenalty = 10;
  final double averageWalkingSpeedMeterPerMinute = 80;
  final double distanceToWalk;

  const WalkEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.distanceToWalk,
  }) : super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );

  @override
  double calcCostToReachNeighbor(double currentTotalTime) {
    double distancePenalty = 0;
    if( distanceToWalk > 100 ) {
      // f(x) = 5^(1/800)x + transferPenalty
      distancePenalty = pow(5, (1 / 800) * distanceToWalk) + transferPenalty;
    }
    double distanceToWalkInMinutes = distanceToWalk / averageWalkingSpeedMeterPerMinute;
    return distanceToWalkInMinutes + distancePenalty;
  }

  @override
  String toString() {
    return 'WALK: ${sourceVertex.name} -> ${targetVertex.name} (${distanceToWalk.toStringAsFixed(2)}m) ${calcCostToReachNeighbor(0).toStringAsFixed(2)}min';
  }
}
