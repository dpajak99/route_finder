import 'package:flutter/material.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';

class WalkEdgeCostTableController {
  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();
  
  final TextEditingController penaltyFunctionTextEditingController = TextEditingController();
  final TextEditingController guaranteedPenaltyTextEditingController = TextEditingController();
  final TextEditingController weightTextEditingController = TextEditingController();
  final TextEditingController speedTextEditingController = TextEditingController();


  WalkEdgeCostTableController() {
    initValues();
  }
  
  void resetValues() {
    pathfinderSettingsCubit.setWalkEdgeCostTable(PathfinderSettingsState().walkEdgeCostTable);
    initValues();
  }

  void initValues() {
    WalkEdgeCostTable walkEdgeCostTable = pathfinderSettingsCubit.state.walkEdgeCostTable;
    
    penaltyFunctionTextEditingController.text = walkEdgeCostTable.walkingDistancePenaltyFunction;
    guaranteedPenaltyTextEditingController.text = walkEdgeCostTable.guaranteedPenaltyForTransfer.toString();
    weightTextEditingController.text = walkEdgeCostTable.weight.toString();
    speedTextEditingController.text = walkEdgeCostTable.speed.toString();
  }

  void save() {
    pathfinderSettingsCubit.setWalkEdgeCostTable(WalkEdgeCostTable(
      walkingDistancePenaltyFunction: penaltyFunctionTextEditingController.text,
      guaranteedPenaltyForTransfer: double.parse(guaranteedPenaltyTextEditingController.text),
      weight: int.parse(weightTextEditingController.text),
      speed: int.parse(speedTextEditingController.text),
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
