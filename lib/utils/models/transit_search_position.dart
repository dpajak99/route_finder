import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_details.dart';

class AlgorithmSearchState {
  final WalkEdgeCostTable walkEdgeCostTable;
  final VehicleEdgeCostTable vehicleEdgeCostTable;
  final EdgeDetails? previousEdge;
  final double totalTimeFromStart;
  final double totalCostFromStart;

  AlgorithmSearchState({
    required this.walkEdgeCostTable,
    required this.vehicleEdgeCostTable,
    required this.totalTimeFromStart,
    required this.totalCostFromStart,
    this.previousEdge,
  });
  
  bool get isFirstEdge =>  previousEdge == null;
}
