import 'package:path_finder/utils/models/cost_table.dart';
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
  
  double get distanceTime;
  int get departureTime;
  int get arrivalTime;
  
  CostTable getCostTable(TransitEdge? previousEdge, double currentTotalTime);
  
  bool isTransitAvailable(TransitEdge? previousEdge, double currentTotalTime);
}