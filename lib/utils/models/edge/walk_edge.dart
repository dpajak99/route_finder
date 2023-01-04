import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdge extends TransitEdge {
  final PathfinderSettingsState pathfinderSettingsState = getIt<PathfinderSettingsCubit>().state;
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
  double get transitStartTime => double.infinity;
  
  @override
  FullEdgeTime calcTime(TransitSearchPosition transitSearchPosition) => FullEdgeTime( waitingTime: 3, transitTime: _walkingTime);

  @override
  double calcCost(TransitSearchPosition transitSearchPosition) {
    FullEdgeTime fullEdgeTime = calcTime(transitSearchPosition);
    
    double specificEdgeCost = pathfinderSettingsState.walkEdgeCostTable.calcCost(distance, fullEdgeTime.total);
    
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
  
  double get _walkingTime => distance / pathfinderSettingsState.walkEdgeCostTable.speed;

  @override
  String toString() {
    return 'WALK: ${sourceVertex.name} -> ${targetVertex.name} (${distance.toStringAsFixed(2)}m) ${_walkingTime.toStringAsFixed(2)}min';
  }
}
