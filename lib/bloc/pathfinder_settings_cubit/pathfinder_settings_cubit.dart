import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/algorithm_type.dart';
import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathfinderSettingsCubit extends Cubit<PathfinderSettingsState> {
  PathfinderSettingsCubit() : super(PathfinderSettingsState());
  
  void setAlgorithmType(AlgorithmType algorithmType) {
    emit(state.copyWith(algorithmType: algorithmType));
  }
  
  void setWalkEdgeCostTable(WalkEdgeCostTable walkEdgeCostTable) {
    emit(state.copyWith(walkEdgeCostTable: walkEdgeCostTable));
  }
  
  void setVehicleEdgeCostTable(VehicleEdgeCostTable vehicleEdgeCostTable) {
    emit(state.copyWith(vehicleEdgeCostTable: vehicleEdgeCostTable));
  }
  
  void setSearchDateTime(DateTime searchDateTime) {
    emit(state.copyWith(searchDateTime: searchDateTime));
  }
  
  void setVertex(StopVertex? sourceVertex, StopVertex? targetVertex) {
    emit(state.copyWithVertex(sourceVertex: sourceVertex, targetVertex: targetVertex));
  }
}