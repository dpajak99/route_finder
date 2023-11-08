
import 'package:path_finder/utils/models/distance.dart';
import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

abstract class TransitEdge extends Edge<StopVertex> {
  final List<String> polylines;
  final Distance distance;
  
  const TransitEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
    required this.distance,
    required this.polylines,
  }) : super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );
  
  double get transitStartTime;

  TransitEdgeTime calcTime(AlgorithmSearchState transitSearchPosition);
  
  double calcCost(AlgorithmSearchState transitSearchPosition);

  bool canReachEdge(AlgorithmSearchState transitSearchPosition);
}

class TransitEdgeTime {
  final double waitingTime;
  final int transitTime;

  double get total => waitingTime + transitTime;

  TransitEdgeTime({
    required this.waitingTime,
    required this.transitTime,
  });
  
  @override
  String toString() {
    return 'FullEdgeTime(waitingTime: $waitingTime, transitTime: $transitTime)';
  }
}
