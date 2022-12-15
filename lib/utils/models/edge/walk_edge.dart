import 'dart:math';

import 'package:path_finder/utils/models/cost_table.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdge extends TransitEdge {
  static const double averageWalkingSpeedMeterPerMinute = 80;
  
  final double distanceToWalk;
  final double _transferTime;

  const WalkEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.distanceToWalk,
  })  : _transferTime = distanceToWalk / averageWalkingSpeedMeterPerMinute,
        super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );

  @override
  double get distanceTime => _transferTime;

  @override
  CostTable getCostTable(TransitEdge? previousEdge, double currentTotalTime) {
    return WalkCostTable(distanceToWalk: distanceToWalk, walkingTime: _transferTime);
  }
  
  @override
  bool isTransitAvailable(TransitEdge? previousEdge, double currentTotalTime) {
    bool nextWalkEdgeInLine = previousEdge is WalkEdge;
    return nextWalkEdgeInLine == false;
  }
  
  @override
  String toString() {
    return 'WALK: ${sourceVertex.name} -> ${targetVertex.name} (${distanceToWalk.toStringAsFixed(2)}m) ${distanceTime.toStringAsFixed(2)}min';
  }
}
