import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/cost_config.dart';

abstract class CostTable extends Equatable {
  const CostTable();

  double calcCost(CostConfig costConfig);

  @override
  List<Object?> get props => <Object?>[];
}

class WalkCostTable extends CostTable {
  final double distanceToWalk;
  final int walkingTime;

  const WalkCostTable({
    required this.distanceToWalk,
    required this.walkingTime,
  });

  @override
  double calcCost(CostConfig costConfig) {
    double walkingPenaltyValue = costConfig.calcWalkingDistancePenalty(distanceToWalk);
    return (walkingTime + walkingPenaltyValue).toDouble();
  }
}

class RideCostTable extends CostTable {
  final double _distanceToRide;
  final int _vehicleTime;
  final int _waitingTime;
  final bool _transfer;

  const RideCostTable({
    required double distanceToRide,
    required int vehicleTime,
    required int waitTime,
    required bool transfer,
  }) : _distanceToRide = distanceToRide,
        _vehicleTime = vehicleTime,
        _waitingTime = waitTime < 0 ? 0 : waitTime,
        _transfer = transfer;

  @override
  double calcCost(CostConfig costConfig) {
    double transitTime = _vehicleTime.toDouble() + _waitingTime.toDouble();
    double transferPenaltyValue = _transfer ? costConfig.rideTableConfigModel.penaltyForTransfer : 0;
    return transitTime + transferPenaltyValue;
  }
}
