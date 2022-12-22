import 'package:flutter/material.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/listeners/edge_cost_config/edge_cost_config.dart';
import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';

class VehicleEdgeCostTableController {
  final EdgeCostConfig edgeCostConfig = getIt<EdgeCostConfig>();

  final TextEditingController transferPenaltyTextEditingController = TextEditingController();
  final TextEditingController penaltyWeightTextEditingController = TextEditingController();
  final TextEditingController waitingTimeWeightTextEditingController = TextEditingController();

  VehicleEdgeCostTableController() {
    initValues();
  }

  void resetValues() {
    edgeCostConfig.resetTransitEdgeCostTable();
    initValues();
  }

  void initValues() {
    VehicleEdgeCostTable vehicleEdgeCostTabled = edgeCostConfig.vehicleEdgeCostTable;
    transferPenaltyTextEditingController.text = vehicleEdgeCostTabled.penaltyForTransfer.toString();
    penaltyWeightTextEditingController.text = vehicleEdgeCostTabled.penaltyWeight.toString();
    waitingTimeWeightTextEditingController.text = vehicleEdgeCostTabled.waitingTimeWeight.toString();
  }

  void save() {
    edgeCostConfig.vehicleEdgeCostTable = VehicleEdgeCostTable(
      penaltyForTransfer: double.parse(transferPenaltyTextEditingController.text),
      penaltyWeight: double.parse(penaltyWeightTextEditingController.text),
      waitingTimeWeight: double.parse(waitingTimeWeightTextEditingController.text),
    );
  }
}
