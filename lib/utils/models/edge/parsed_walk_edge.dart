import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class ParsedWalkEdge extends WalkEdge {
  final int _departureTime;

  const ParsedWalkEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required double distanceToWalk,
    required int departureTime,
  })  : _departureTime = departureTime,
        super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
          distanceToWalk: distanceToWalk,
        );
  
  factory ParsedWalkEdge.fromWalkEdge(WalkEdge walkEdge, int currentTotalTime) {
    return ParsedWalkEdge(
      sourceVertex: walkEdge.sourceVertex,
      targetVertex: walkEdge.targetVertex,
      distanceToWalk: walkEdge.distanceToWalk,
      departureTime: currentTotalTime,
    );
  }

  @override
  int get arrivalTime => _departureTime + distanceTime.toInt();

  @override
  int get departureTime => _departureTime;
}
