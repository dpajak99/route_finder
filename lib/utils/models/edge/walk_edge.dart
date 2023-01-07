import 'package:path_finder/infra/entity/walk_edge_entity.dart';
import 'package:path_finder/utils/models/distance.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdge extends TransitEdge {
  WalkEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required int distanceInMeters,
    required List<String> polylines,
  }) : super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
          distance: Distance(meters: distanceInMeters),
          polylines: polylines,
        );

  factory WalkEdge.fromEntity(WalkEdgeEntity walkEdgeEntity, StopVertex sourceVertex, StopVertex targetVertex) {
    return WalkEdge(
      sourceVertex: sourceVertex,
      targetVertex: targetVertex,
      distanceInMeters: walkEdgeEntity.distanceInMeters,
      polylines: walkEdgeEntity.polylines,
    );
  }

  @override
  double get transitStartTime => double.infinity;

  @override
  TransitEdgeTime calcTime(AlgorithmSearchState transitSearchPosition) {
    return TransitEdgeTime(
      waitingTime: 3,
      transitTime: calcWalkingTime(transitSearchPosition.walkEdgeCostTable.speed),
    );
  }

  @override
  double calcCost(AlgorithmSearchState transitSearchPosition) {
    TransitEdgeTime fullEdgeTime = calcTime(transitSearchPosition);

    double specificEdgeCost = transitSearchPosition.walkEdgeCostTable.calcCost(distance, fullEdgeTime.total);

    return specificEdgeCost;
  }

  @override
  bool canReachEdge(AlgorithmSearchState transitSearchPosition) {
    if (transitSearchPosition.isFirstEdge) {
      return true;
    }
    bool nextWalkEdgeInLine = transitSearchPosition.previousEdge?.transitEdge is WalkEdge;
    return nextWalkEdgeInLine == false;
  }

  int calcWalkingTime(int speed) => distance.inMeters ~/ speed;

  @override
  String toString() {
    return 'WALK: ${sourceVertex.name} -> ${targetVertex.name} (${distance})';
  }
}
