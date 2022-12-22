import 'package:flutter/material.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/listeners/edge_cost_config/edge_cost_config.dart';
import 'package:path_finder/utils/models/edge_cost_table/transit_edge_cost_table.dart';

class TransitEdgeCostTableController {
  final EdgeCostConfig edgeCostConfig = getIt<EdgeCostConfig>();
  
  final TextEditingController transitTimeWeightTextEditingController = TextEditingController();
  final TextEditingController distanceWeightTextEditingController = TextEditingController();

  TransitEdgeCostTableController() {
    initValues();
  }
  
  void resetValues() {
    edgeCostConfig.resetTransitEdgeCostTable();
    initValues();
  }
  
  void initValues() {
    TransitEdgeCostTable transitEdgeCostTable = edgeCostConfig.transitEdgeCostTable;
    transitTimeWeightTextEditingController.text = transitEdgeCostTable.transitTimeWeight.toString();
    distanceWeightTextEditingController.text = transitEdgeCostTable.distanceWeight.toString();
  }
  
  void save() {
    edgeCostConfig.transitEdgeCostTable = TransitEdgeCostTable(
      transitTimeWeight: double.parse(transitTimeWeightTextEditingController.text),
      distanceWeight: double.parse(distanceWeightTextEditingController.text),
    );
  }
}
