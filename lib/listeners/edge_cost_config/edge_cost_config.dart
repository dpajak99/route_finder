import 'package:flutter/cupertino.dart';
import 'package:path_finder/utils/models/edge_cost_table/transit_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';

class EdgeCostConfig {
  final TransitEdgeCostTable _defaultTransitEdgeCostTable = TransitEdgeCostTable(
    distanceWeight: 0,
    transitTimeWeight: 1,
  );

  final WalkEdgeCostTable _defaultWalkEdgeCostTable = WalkEdgeCostTable(
    walkingDistancePenaltyFunction: '5^((1/800)*x) + a',
    guaranteedPenaltyForTransfer: 10,
    speed: 50,
    weight: 1,
  );

  final VehicleEdgeCostTable _defaultVehicleEdgeCostTable = VehicleEdgeCostTable(
      penaltyForTransfer: 15,
      penaltyWeight: 1,
      waitingTimeWeight: 1
  );

  late final ValueNotifier<TransitEdgeCostTable> transitEdgeCostTableNotifier = ValueNotifier<TransitEdgeCostTable>(_defaultTransitEdgeCostTable);
  late final ValueNotifier<WalkEdgeCostTable> walkEdgeCostTableNotifier = ValueNotifier<WalkEdgeCostTable>(_defaultWalkEdgeCostTable);
  late final ValueNotifier<VehicleEdgeCostTable> vehicleEdgeCostTableNotifier = ValueNotifier<VehicleEdgeCostTable>(_defaultVehicleEdgeCostTable);

  void resetTransitEdgeCostTable() {
    transitEdgeCostTableNotifier.value = _defaultTransitEdgeCostTable;
  }
  
  void resetWalkEdgeCostTable() {
    walkEdgeCostTableNotifier.value = _defaultWalkEdgeCostTable;
  }
  
  void resetVehicleEdgeCostTable() {
    vehicleEdgeCostTableNotifier.value = _defaultVehicleEdgeCostTable;
  }

  TransitEdgeCostTable get transitEdgeCostTable => transitEdgeCostTableNotifier.value;
  WalkEdgeCostTable get walkEdgeCostTable => walkEdgeCostTableNotifier.value;
  VehicleEdgeCostTable get vehicleEdgeCostTable => vehicleEdgeCostTableNotifier.value;
  
  set transitEdgeCostTable(TransitEdgeCostTable value) => transitEdgeCostTableNotifier.value = value;
  set walkEdgeCostTable(WalkEdgeCostTable value) => walkEdgeCostTableNotifier.value = value;
  set vehicleEdgeCostTable(VehicleEdgeCostTable value) => vehicleEdgeCostTableNotifier.value = value;
}