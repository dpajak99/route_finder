import 'package:equatable/equatable.dart';

abstract class PathfinderState extends Equatable {}

class PathfinderLoadingState extends PathfinderState {
  @override
  List<Object?> get props => <Object>[];
}

class PathfinderLoadedState extends PathfinderState {

  @override
  List<Object?> get props => <Object>[];
}