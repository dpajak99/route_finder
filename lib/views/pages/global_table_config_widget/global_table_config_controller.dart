import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/global_table_config_model.dart';

class GlobalTableController {
  final TextEditingController transitTimeWeightTextEditingController = TextEditingController();
  final TextEditingController distanceWeightTextEditingController = TextEditingController();

  final GlobalTableConfigModel initialGlobalTableConfigModel;
  final ValueNotifier<GlobalTableConfigModel> currentGlobalTableConfigModel;

  GlobalTableController({
    required this.initialGlobalTableConfigModel,
  }) : currentGlobalTableConfigModel = ValueNotifier<GlobalTableConfigModel>(initialGlobalTableConfigModel) {
    resetValues();
  }
  
  void resetValues() {
    transitTimeWeightTextEditingController.text = initialGlobalTableConfigModel.transitTimeWeight.toString();
    distanceWeightTextEditingController.text = initialGlobalTableConfigModel.distanceWeight.toString();
  }
  
  void save() {
    currentGlobalTableConfigModel.value = GlobalTableConfigModel(
      transitTimeWeight: double.tryParse(transitTimeWeightTextEditingController.text) ?? initialGlobalTableConfigModel.transitTimeWeight,
      distanceWeight: double.tryParse(distanceWeightTextEditingController.text) ?? initialGlobalTableConfigModel.distanceWeight,
    );
  }
}
