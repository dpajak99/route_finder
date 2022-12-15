import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

abstract class TransitEdge extends Edge<StopVertex>{
  const TransitEdge({
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
  }) : super(
    sourceVertex: sourceVertex,
    targetVertex: targetVertex,
  );
  
  double calcCostToReachNeighbor(double currentTotalTime);
}