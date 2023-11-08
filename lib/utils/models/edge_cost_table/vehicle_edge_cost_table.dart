import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_cost_table/edge_cost_table.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdgeCostTable implements EdgeCostTable<StopVertex, VehicleEdge> {
  final double penaltyForTransfer;

  VehicleEdgeCostTable({
    required this.penaltyForTransfer,
  });

  VehicleEdgeCostTable copyWith({
    double? penaltyForTransfer,
    double? penaltyWeight,
    double? waitingTimeWeight,
  }) {
    return VehicleEdgeCostTable(
      penaltyForTransfer: penaltyForTransfer ?? this.penaltyForTransfer,
    );
  }
  
  double calcCost({required TransitEdgeTime fullEdgeTime, required bool isTransfer}) {
    double timeCost = fullEdgeTime.total;
    double transferPenalty = isTransfer ? penaltyForTransfer : 0;
    return timeCost + transferPenalty;
  }
}