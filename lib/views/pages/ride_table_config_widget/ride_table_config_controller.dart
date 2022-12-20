import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/ride_table_config_model.dart';

class RideTableController {
  final TextEditingController transferPenaltyTextEditingController = TextEditingController();
  final TextEditingController penaltyWeightTextEditingController = TextEditingController();
  final TextEditingController waitingTimeWeightTextEditingController = TextEditingController();

  final RideTableConfigModel initialRideTableConfigModel;
  final ValueNotifier<RideTableConfigModel> currentRideTableConfigModel;

  RideTableController({
    required this.initialRideTableConfigModel,
  }) : currentRideTableConfigModel = ValueNotifier<RideTableConfigModel>(initialRideTableConfigModel) {
    resetValues();
  }
  
  void resetValues() {
    transferPenaltyTextEditingController.text = initialRideTableConfigModel.penaltyForTransfer.toString();
    penaltyWeightTextEditingController.text = initialRideTableConfigModel.penaltyWeight.toString();
    waitingTimeWeightTextEditingController.text = initialRideTableConfigModel.waitingTimeWeight.toString();
  }
  
  void save() {
    currentRideTableConfigModel.value = RideTableConfigModel(
      penaltyForTransfer: double.tryParse(transferPenaltyTextEditingController.text) ?? initialRideTableConfigModel.penaltyForTransfer,
      penaltyWeight: double.tryParse(penaltyWeightTextEditingController.text) ?? initialRideTableConfigModel.penaltyWeight,
      waitingTimeWeight: double.tryParse(waitingTimeWeightTextEditingController.text) ?? initialRideTableConfigModel.waitingTimeWeight,
    );
  }
}
