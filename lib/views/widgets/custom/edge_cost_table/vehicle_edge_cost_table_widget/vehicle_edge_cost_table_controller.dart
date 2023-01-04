import 'package:flutter/material.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';

class VehicleEdgeCostTableController {
  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();

  final TextEditingController transferPenaltyTextEditingController = TextEditingController();
  final TextEditingController penaltyWeightTextEditingController = TextEditingController();
  final TextEditingController waitingTimeWeightTextEditingController = TextEditingController();

  VehicleEdgeCostTableController() {
    initValues();
  }

  void resetValues() {
    pathfinderSettingsCubit.setVehicleEdgeCostTable(PathfinderSettingsState().vehicleEdgeCostTable);
    initValues();
  }

  void initValues() {
    VehicleEdgeCostTable vehicleEdgeCostTabled = pathfinderSettingsCubit.state.vehicleEdgeCostTable;
    transferPenaltyTextEditingController.text = vehicleEdgeCostTabled.penaltyForTransfer.toString();
    penaltyWeightTextEditingController.text = vehicleEdgeCostTabled.penaltyWeight.toString();
    waitingTimeWeightTextEditingController.text = vehicleEdgeCostTabled.waitingTimeWeight.toString();
  }

  void save() {
    pathfinderSettingsCubit.setVehicleEdgeCostTable(VehicleEdgeCostTable(
      penaltyForTransfer: double.parse(transferPenaltyTextEditingController.text),
      penaltyWeight: double.parse(penaltyWeightTextEditingController.text),
      waitingTimeWeight: double.parse(waitingTimeWeightTextEditingController.text),
    ));
  }
}
