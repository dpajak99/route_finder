import 'package:flutter/material.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/listeners/edge_cost_config/edge_cost_config.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';

class WalkEdgeCostTableController {
  final EdgeCostConfig edgeCostConfig = getIt<EdgeCostConfig>();
  
  final TextEditingController penaltyFunctionTextEditingController = TextEditingController();
  final TextEditingController guaranteedPenaltyTextEditingController = TextEditingController();
  final TextEditingController weightTextEditingController = TextEditingController();
  final TextEditingController speedTextEditingController = TextEditingController();


  WalkEdgeCostTableController() {
    initValues();
  }
  
  void resetValues() {
    edgeCostConfig.resetTransitEdgeCostTable();
    initValues();
  }

  void initValues() {
    WalkEdgeCostTable walkEdgeCostTable = edgeCostConfig.walkEdgeCostTable;
    
    penaltyFunctionTextEditingController.text = walkEdgeCostTable.walkingDistancePenaltyFunction;
    guaranteedPenaltyTextEditingController.text = walkEdgeCostTable.guaranteedPenaltyForTransfer.toString();
    weightTextEditingController.text = walkEdgeCostTable.weight.toString();
    speedTextEditingController.text = walkEdgeCostTable.speed.toString();
  }

  void save() {
    edgeCostConfig.walkEdgeCostTable = WalkEdgeCostTable(
      walkingDistancePenaltyFunction: penaltyFunctionTextEditingController.text,
      guaranteedPenaltyForTransfer: double.parse(guaranteedPenaltyTextEditingController.text),
      weight: int.parse(weightTextEditingController.text),
      speed: int.parse(speedTextEditingController.text),
    );
  }
  set penaltyFunction(String value) {
    edgeCostConfig.walkEdgeCostTable = edgeCostConfig.walkEdgeCostTable.copyWith(walkingDistancePenaltyFunction: value);
  }
  
  set guaranteedPenaltyForTransfer(double value) {
    edgeCostConfig.walkEdgeCostTable = edgeCostConfig.walkEdgeCostTable.copyWith(guaranteedPenaltyForTransfer: value);
  }
  
  set weight(int value) {
    edgeCostConfig.walkEdgeCostTable = edgeCostConfig.walkEdgeCostTable.copyWith(weight: value);
  }
  
  set speed(int value) {
    edgeCostConfig.walkEdgeCostTable = edgeCostConfig.walkEdgeCostTable.copyWith(speed: value);
  }
}
