import 'dart:math';

import 'package:math_parser/math_parser.dart';
import 'package:path_finder/utils/models/global_table_config_model.dart';
import 'package:path_finder/utils/models/ride_table_config_model.dart';
import 'package:path_finder/utils/models/walking_table_config_model.dart';

class CostConfig {
  GlobalTableConfigModel globalTableConfigModel = GlobalTableConfigModel(
    distanceWeight: 0,
    transitTimeWeight: 1,
  );
  
  WalkingTableConfigModel walkingTableConfigModel = WalkingTableConfigModel(
    penaltyFunction: '5^((1/800)*x) + a',
    guaranteedPenaltyForTransfer: 100,
    speed: 80,
    weight: 1,
  );
  
  RideTableConfigModel rideTableConfigModel = RideTableConfigModel(
      penaltyForTransfer: 3,
      penaltyWeight: 1,
      waitingTimeWeight: 1
  );

  double calcWalkingDistancePenalty(double distanceToWalk) {
    double distancePenalty = MathNodeExpression.fromString(
          walkingTableConfigModel.penaltyFunction,
          variableNames: const <String>{'x', 'a'},
        ).calc(
          MathVariableValues(<String, double>{
            'x': distanceToWalk,
            'a': walkingTableConfigModel.guaranteedPenaltyForTransfer.toDouble(),
          }),
        ).toDouble();
 
    return distancePenalty;
  }
  
  
}