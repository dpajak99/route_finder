import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_cost_table/edge_cost_table.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdgeCostTable implements EdgeCostTable<StopVertex, VehicleEdge> {
  final double penaltyForTransfer;
  final double penaltyWeight;
  final double waitingTimeWeight;

  VehicleEdgeCostTable({
    required this.penaltyForTransfer,
    required this.penaltyWeight,
    required this.waitingTimeWeight,
  });

  VehicleEdgeCostTable copyWith({
    double? penaltyForTransfer,
    double? penaltyWeight,
    double? waitingTimeWeight,
  }) {
    return VehicleEdgeCostTable(
      penaltyForTransfer: penaltyForTransfer ?? this.penaltyForTransfer,
      penaltyWeight: penaltyWeight ?? this.penaltyWeight,
      waitingTimeWeight: waitingTimeWeight ?? this.waitingTimeWeight,
    );
  }
  
  double calcCost({required FullEdgeTime fullEdgeTime, required bool isTransfer}) {
    double timeCost = fullEdgeTime.waitingTime + fullEdgeTime.transitTime;
    double transferPenalty = isTransfer ? penaltyForTransfer : 0;
    return timeCost + transferPenalty;
  }
}