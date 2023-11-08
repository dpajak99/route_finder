import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/algorithm_type.dart';
import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathfinderSettingsState extends Equatable {
  final AlgorithmType algorithmType;
  final WalkEdgeCostTable walkEdgeCostTable;
  final VehicleEdgeCostTable vehicleEdgeCostTable;
  final DateTime searchDateTime;
  final StopVertex? sourceVertex;
  final StopVertex? targetVertex;

  PathfinderSettingsState({
    AlgorithmType? algorithmType,
    WalkEdgeCostTable? walkEdgeCostTable,
    VehicleEdgeCostTable? vehicleEdgeCostTable,
    DateTime? searchDateTime,
    this.sourceVertex,
    this.targetVertex,
  })  : algorithmType = algorithmType ?? AlgorithmType.dijkstra,
        walkEdgeCostTable = walkEdgeCostTable ??
            WalkEdgeCostTable(
              walkingDistancePenaltyFunction: '(x/100)^2 + a',
              guaranteedPenaltyForTransfer: 30,
              speed: 50,
            ),
        vehicleEdgeCostTable = vehicleEdgeCostTable ?? VehicleEdgeCostTable(penaltyForTransfer: 15),
        searchDateTime = searchDateTime ?? DateTime(2022, 12, 15, 6, 0);

  PathfinderSettingsState copyWith({
    AlgorithmType? algorithmType,
    WalkEdgeCostTable? walkEdgeCostTable,
    VehicleEdgeCostTable? vehicleEdgeCostTable,
    DateTime? searchDateTime,
    StopVertex? sourceVertex,
    StopVertex? targetVertex,
  }) {
    return PathfinderSettingsState(
      algorithmType: algorithmType ?? this.algorithmType,
      walkEdgeCostTable: walkEdgeCostTable ?? this.walkEdgeCostTable,
      vehicleEdgeCostTable: vehicleEdgeCostTable ?? this.vehicleEdgeCostTable,
      searchDateTime: searchDateTime ?? this.searchDateTime,
      sourceVertex: sourceVertex ?? this.sourceVertex,
      targetVertex: targetVertex ?? this.targetVertex,
    );
  }

  PathfinderSettingsState copyWithVertex({StopVertex? sourceVertex, StopVertex? targetVertex}) {
    return PathfinderSettingsState(
      algorithmType: algorithmType,
      walkEdgeCostTable: walkEdgeCostTable,
      vehicleEdgeCostTable: vehicleEdgeCostTable,
      searchDateTime: searchDateTime,
      sourceVertex: sourceVertex,
      targetVertex: targetVertex,
    );
  }
  
  bool get filled => sourceVertex != null && targetVertex != null;

  @override
  List<Object?> get props => <Object?>[algorithmType, walkEdgeCostTable, vehicleEdgeCostTable, searchDateTime, sourceVertex, targetVertex];
}

class PathfinderSettingsReadyState extends PathfinderSettingsState {
  PathfinderSettingsReadyState({
    required AlgorithmType algorithmType,
    required WalkEdgeCostTable walkEdgeCostTable,
    required VehicleEdgeCostTable vehicleEdgeCostTable,
    required DateTime searchDateTime,
    required StopVertex sourceVertex,
    required StopVertex targetVertex,
  }) : super(
          algorithmType: algorithmType,
          walkEdgeCostTable: walkEdgeCostTable,
          vehicleEdgeCostTable: vehicleEdgeCostTable,
          searchDateTime: searchDateTime,
          sourceVertex: sourceVertex,
          targetVertex: targetVertex,
        );
  
  @override
  StopVertex get sourceVertex => super.sourceVertex!;
  
  @override
  StopVertex get targetVertex => super.targetVertex!;

  @override
  List<Object?> get props => <Object?>[algorithmType, walkEdgeCostTable, vehicleEdgeCostTable, searchDateTime, sourceVertex, targetVertex];
}
