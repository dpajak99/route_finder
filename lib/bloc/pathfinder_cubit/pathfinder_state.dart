import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';

abstract class PathfinderState extends Equatable {}

class PathfinderLoadingState extends PathfinderState {
  @override
  List<Object?> get props => <Object>[];
}

class PathfinderLoadedState extends PathfinderState {

  @override
  List<Object?> get props => <Object>[];
}