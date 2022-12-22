import 'package:path_finder/config/locator.dart';
import 'package:path_finder/listeners/edge_cost_config/edge_cost_config.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdge extends TransitEdge {
  final EdgeCostConfig edgeCostConfig = getIt<EdgeCostConfig>();
  final double distance;

  WalkEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.distance,
  }) : super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );
  
  @override
  FullEdgeTime calcTime(TransitSearchPosition transitSearchPosition) => FullEdgeTime( waitingTime: 0, transitTime: _walkingTime);
  

  @override
  double calcCost(TransitSearchPosition transitSearchPosition) {
    FullEdgeTime fullEdgeTime = calcTime(transitSearchPosition);
    
    double specificEdgeCost = edgeCostConfig.walkEdgeCostTable.calcCost(distance, fullEdgeTime.total);
    // double globalEdgeCost = edgeCostConfig.transitEdgeCostTable.calcCost(fullEdgeTime.total, distance);
    
    return specificEdgeCost;
  }

  @override
  bool canReachEdge(TransitSearchPosition transitSearchPosition) {
    if (transitSearchPosition.isFirstEdge) {
      return true;
    }
    bool nextWalkEdgeInLine = transitSearchPosition.previousTransitEdgeResult?.transitEdge is WalkEdge;
    bool edgeTimeExpired = transitSearchPosition.previousTransitEdgeResult!.edgeTimeEnd > transitSearchPosition.totalTimeFromStart;
    return nextWalkEdgeInLine == false && edgeTimeExpired == false;
  }
  
  double get _walkingTime => distance / edgeCostConfig.walkEdgeCostTable.speed;

  @override
  String toString() {
    return 'WALK: ${sourceVertex.name} -> ${targetVertex.name} (${distance.toStringAsFixed(2)}m) ${_walkingTime.toStringAsFixed(2)}min';
  }
}
