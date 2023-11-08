import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

enum StopActiveSelection { source, target, none }

class StopSelectState extends Equatable {
  final StopActiveSelection stopActiveSelection;
  final StopVertex? sourceVertex;
  final StopVertex? targetVertex;

  const StopSelectState({
    required this.stopActiveSelection,
    this.sourceVertex,
    this.targetVertex,
  });
  
  StopSelectState copyWith({
    StopActiveSelection? stopActiveSelection,
    DateTime? dateTime,
    StopVertex? sourceVertex,
    StopVertex? targetVertex,
  }) {
    return StopSelectState(
      stopActiveSelection: stopActiveSelection ?? this.stopActiveSelection,
      sourceVertex: sourceVertex ?? this.sourceVertex,
      targetVertex: targetVertex ?? this.targetVertex,
    );
  }
  
  bool get isComplete => sourceVertex != null && targetVertex != null;

  @override
  List<Object?> get props => <Object?>[stopActiveSelection,  sourceVertex, targetVertex];
}
