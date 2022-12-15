import 'dart:math';

class CostConfig {
  final double _walkingTransferPenalty = 10;
  final double vehicleTransferPenalty = 10;

  final double transferTimeWeight = 1;
  final double distanceWeight = 0;

  double calcWalkingDistancePenalty(double distanceToWalk) {
    double distancePenalty = 0;
    if (distanceToWalk > 100) {
      // f(x) = 5^(1/800)x + transferPenalty
      distancePenalty = pow(5, (1 / 800) * distanceToWalk) + _walkingTransferPenalty;
    }
    return distancePenalty;
  }
}