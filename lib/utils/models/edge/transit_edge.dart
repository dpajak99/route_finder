import 'package:path_finder/utils/models/cost_table.dart';
import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

abstract class TransitEdge extends Edge<StopVertex> {
  const TransitEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
  }) : super(
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );

  CostTable buildCostTable(TransitEdge? previousEdge, int currentTotalTime);

  bool isTransitAvailable(TransitEdgeResult? previousEdgeResult, int currentTotalTime);

  FullEdgeTime calcFullEdgeTime(int currentTotalTime);
}

class FullEdgeTime {
  final int waitingTime;
  final int transitTime;
  
  int get total => waitingTime + transitTime;

  FullEdgeTime({
    required this.waitingTime,
    required this.transitTime,
  });
}
