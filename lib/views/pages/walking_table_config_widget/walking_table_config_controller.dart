import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/walking_table_config_model.dart';

class WalkingTableController {
  final TextEditingController penaltyFunctionTextEditingController = TextEditingController();
  final TextEditingController guaranteedPenaltyTextEditingController = TextEditingController();
  final TextEditingController weightTextEditingController = TextEditingController();
  final TextEditingController speedTextEditingController = TextEditingController();

  final WalkingTableConfigModel initialWalkingTableConfigModel;
  final ValueNotifier<WalkingTableConfigModel> currentWalkingTableConfigModel;
  
  WalkingTableController({
    required this.initialWalkingTableConfigModel,
  }) : currentWalkingTableConfigModel = ValueNotifier<WalkingTableConfigModel>(initialWalkingTableConfigModel) {
    resetValues();
  }
  
  void resetValues() {
    penaltyFunctionTextEditingController.text = initialWalkingTableConfigModel.penaltyFunction;
    guaranteedPenaltyTextEditingController.text = initialWalkingTableConfigModel.guaranteedPenaltyForTransfer.toString();
    weightTextEditingController.text = initialWalkingTableConfigModel.weight.toString();
    speedTextEditingController.text = initialWalkingTableConfigModel.speed.toString();
    currentWalkingTableConfigModel.value = initialWalkingTableConfigModel;
  }

  void save() {
    currentWalkingTableConfigModel.value = WalkingTableConfigModel(
      penaltyFunction: penaltyFunctionTextEditingController.text,
      guaranteedPenaltyForTransfer: double.tryParse(guaranteedPenaltyTextEditingController.text) ?? initialWalkingTableConfigModel.guaranteedPenaltyForTransfer,
      weight: int.tryParse(weightTextEditingController.text) ?? initialWalkingTableConfigModel.weight,
      speed: int.tryParse(speedTextEditingController.text) ?? initialWalkingTableConfigModel.speed,
    );
  }
  set penaltyFunction(String value) {
    currentWalkingTableConfigModel.value = currentWalkingTableConfigModel.value.copyWith(penaltyFunction: value);
  }
  
  set guaranteedPenaltyForTransfer(double value) {
    currentWalkingTableConfigModel.value = currentWalkingTableConfigModel.value.copyWith(guaranteedPenaltyForTransfer: value);
  }
  
  set weight(int value) {
    currentWalkingTableConfigModel.value = currentWalkingTableConfigModel.value.copyWith(weight: value);
  }
  
  set speed(int value) {
    currentWalkingTableConfigModel.value = currentWalkingTableConfigModel.value.copyWith(speed: value);
  }
}
