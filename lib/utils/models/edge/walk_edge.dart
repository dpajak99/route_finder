import 'package:path_finder/infra/entity/walk_edge_entity.dart';
import 'package:path_finder/utils/models/distance.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdge extends TransitEdge {
  final Distance distance;

  const WalkEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.distance,
  }) : super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );
  
  factory WalkEdge.fromEntity(WalkEdgeEntity walkEdgeEntity, StopVertex sourceVertex, StopVertex targetVertex) {
    return WalkEdge(
      sourceVertex: sourceVertex,
      targetVertex: targetVertex,
      distance: Distance( meters: walkEdgeEntity.distanceInMeters),
    );
  }

  @override
  double get transitStartTime => double.infinity;

  @override
  FullEdgeTime calcTime(TransitSearchPosition transitSearchPosition) {
    return FullEdgeTime(
      waitingTime: 3,
      transitTime: calcWalkingDistance(transitSearchPosition.walkEdgeCostTable.speed),
    );
  }

  @override
  double calcCost(TransitSearchPosition transitSearchPosition) {
    FullEdgeTime fullEdgeTime = calcTime(transitSearchPosition);

    double specificEdgeCost = transitSearchPosition.walkEdgeCostTable.calcCost(distance, fullEdgeTime.total);

    return specificEdgeCost;
  }

  @override
  bool canReachEdge(TransitSearchPosition transitSearchPosition) {
    if (transitSearchPosition.isFirstEdge) {
      return true;
    }
    bool nextWalkEdgeInLine = transitSearchPosition.previousEdge?.transitEdge is WalkEdge;
    return nextWalkEdgeInLine == false;
  }

  double calcWalkingDistance(int speed) => distance.inMeters / speed;

  @override
  String toString() {
    return 'WALK: ${sourceVertex.name} -> ${targetVertex.name} (${distance})';
  }
}
