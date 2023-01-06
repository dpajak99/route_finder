import 'package:math_parser/math_parser.dart';
import 'package:path_finder/utils/models/distance.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_cost_table/edge_cost_table.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class WalkEdgeCostTable implements EdgeCostTable<StopVertex, VehicleEdge> {
  final String walkingDistancePenaltyFunction;
  final double guaranteedPenaltyForTransfer;
  final int speed;

  WalkEdgeCostTable({
    required this.walkingDistancePenaltyFunction,
    required this.guaranteedPenaltyForTransfer,
    required this.speed,
  });

  WalkEdgeCostTable copyWith({
    String? walkingDistancePenaltyFunction,
    double? guaranteedPenaltyForTransfer,
    int? weight,
    int? speed,
  }) {
    return WalkEdgeCostTable(
      walkingDistancePenaltyFunction: walkingDistancePenaltyFunction ?? this.walkingDistancePenaltyFunction,
      guaranteedPenaltyForTransfer: guaranteedPenaltyForTransfer ?? this.guaranteedPenaltyForTransfer,
      speed: speed ?? this.speed,
    );
  }
  
  double calcCost(Distance distance, double time) {
    double walkingDistancePenalty = _calcWalkingDistancePenalty(distance);
    return walkingDistancePenalty + time;
  }
  

  double _calcWalkingDistancePenalty(Distance distanceToWalk) {
    double x = distanceToWalk.inMeters;
    double a = guaranteedPenaltyForTransfer;

    double distancePenalty = MathNodeExpression.fromString(walkingDistancePenaltyFunction, variableNames: const <String>{'x', 'a'})
        .calc(MathVariableValues(<String, double>{'x': x, 'a': a}))
        .toDouble();

    return distancePenalty;
  }
}
