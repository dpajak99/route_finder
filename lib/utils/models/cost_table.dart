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
  final double walkingTime;

  const WalkCostTable({
    required this.distanceToWalk,
    required this.walkingTime,
  });
  
  @override
  double calcCost(CostConfig costConfig) {
    double distancePenalty = costConfig.calcWalkingDistancePenalty(distanceToWalk);
    double walkingTimePenalty = walkingTime * costConfig.transferTimeWeight;
    return distancePenalty + walkingTimePenalty + costConfig.transferTimeWeight;
  }
}

class RideCostTable extends CostTable {
  final double distanceToRide;
  final double transferTime;
  final double waitingTime;
  final bool transfer;

  const RideCostTable({
    required this.distanceToRide,
    required this.transferTime,
    required this.waitingTime,
    required this.transfer,
  });
  
  @override
  double calcCost(CostConfig costConfig) {
    double distancePenalty = distanceToRide * costConfig.distanceWeight;
    double rideTimePenalty = transferTime * costConfig.transferTimeWeight;
    double transferPenalty = transfer ? costConfig.vehicleTransferPenalty : 0;
    
    return distancePenalty + rideTimePenalty + transferPenalty;
  }
}