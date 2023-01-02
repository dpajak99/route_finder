import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

abstract class TransitEdge extends Edge<StopVertex> {
  const TransitEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
  }) : super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );
  
  double get transitStartTime;

  FullEdgeTime calcTime(TransitSearchPosition transitSearchPosition);
  
  double calcCost(TransitSearchPosition transitSearchPosition);

  bool canReachEdge(TransitSearchPosition transitSearchPosition);
}

class FullEdgeTime {
  final double waitingTime;
  final double transitTime;

  double get total => waitingTime + transitTime;

  FullEdgeTime({
    required this.waitingTime,
    required this.transitTime,
  });
  
  @override
  String toString() {
    return 'FullEdgeTime(waitingTime: $waitingTime, transitTime: $transitTime)';
  }
}
