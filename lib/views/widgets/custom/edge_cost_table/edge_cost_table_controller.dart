import 'package:flutter/material.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';

class EdgeCostTableController {
  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();

  final TextEditingController transferPenaltyTextEditingController = TextEditingController();
  final TextEditingController penaltyWeightTextEditingController = TextEditingController();
  final TextEditingController waitingTimeWeightTextEditingController = TextEditingController();
  final TextEditingController penaltyFunctionTextEditingController = TextEditingController();
  final TextEditingController guaranteedPenaltyTextEditingController = TextEditingController();
  final TextEditingController weightTextEditingController = TextEditingController();
  final TextEditingController speedTextEditingController = TextEditingController();


  EdgeCostTableController() {
    initValues();
  }

  void resetValues() {
    pathfinderSettingsCubit.setVehicleEdgeCostTable(PathfinderSettingsState().vehicleEdgeCostTable);
    pathfinderSettingsCubit.setWalkEdgeCostTable(PathfinderSettingsState().walkEdgeCostTable);
    initValues();
  }

  void initValues() {
    WalkEdgeCostTable walkEdgeCostTable = pathfinderSettingsCubit.state.walkEdgeCostTable;

    penaltyFunctionTextEditingController.text = walkEdgeCostTable.walkingDistancePenaltyFunction;
    guaranteedPenaltyTextEditingController.text = walkEdgeCostTable.guaranteedPenaltyForTransfer.toString();
    speedTextEditingController.text = walkEdgeCostTable.speed.toString();

    VehicleEdgeCostTable vehicleEdgeCostTabled = pathfinderSettingsCubit.state.vehicleEdgeCostTable;
    transferPenaltyTextEditingController.text = vehicleEdgeCostTabled.penaltyForTransfer.toString();
  }

  void save() {
    pathfinderSettingsCubit.setWalkEdgeCostTable(WalkEdgeCostTable(
      walkingDistancePenaltyFunction: penaltyFunctionTextEditingController.text,
      guaranteedPenaltyForTransfer: double.parse(guaranteedPenaltyTextEditingController.text),
      speed: int.parse(speedTextEditingController.text),
    ));

    pathfinderSettingsCubit.setVehicleEdgeCostTable(VehicleEdgeCostTable(
      penaltyForTransfer: double.parse(transferPenaltyTextEditingController.text),
    ));
  }
  set penaltyFunction(String value) {
    pathfinderSettingsCubit.setWalkEdgeCostTable(pathfinderSettingsCubit.state.walkEdgeCostTable.copyWith(walkingDistancePenaltyFunction: value));
  }

  set guaranteedPenaltyForTransfer(double value) {
    pathfinderSettingsCubit.setWalkEdgeCostTable(pathfinderSettingsCubit.state.walkEdgeCostTable.copyWith(guaranteedPenaltyForTransfer: value));
  }

  set weight(int value) {
    pathfinderSettingsCubit.setWalkEdgeCostTable(pathfinderSettingsCubit.state.walkEdgeCostTable.copyWith(weight: value));
  }

  set speed(int value) {
    pathfinderSettingsCubit.setWalkEdgeCostTable(pathfinderSettingsCubit.state.walkEdgeCostTable.copyWith(speed: value));
  }
}
