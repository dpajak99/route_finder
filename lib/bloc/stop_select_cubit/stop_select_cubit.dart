import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_state.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopSelectCubit extends Cubit<StopSelectState> {
  StopSelectCubit()
      : super(StopSelectState(
          stopActiveSelection: StopActiveSelection.none,
          dateTime: DateTime(2022, 12, 15, 14, 0),
        ));

  void setActiveSelection(StopActiveSelection stopActiveSelection) {
    emit(state.copyWith(stopActiveSelection: stopActiveSelection));
  }
  
  void setDateTime(DateTime dateTime) {
    emit(state.copyWith(dateTime: dateTime));
  }

  void updateSelectedVertex(StopVertex stopVertex) {
    switch (state.stopActiveSelection) {
      case StopActiveSelection.source:
        emit(state.copyWith(sourceVertex: stopVertex));
        break;
      case StopActiveSelection.target:
        emit(state.copyWith(targetVertex: stopVertex));
        break;
      case StopActiveSelection.none:
        break;
    }
  }

  void setSourceVertex(StopVertex? sourceVertex) {
    emit(StopSelectState(
      sourceVertex: sourceVertex,
      dateTime: state.dateTime,
      targetVertex: state.targetVertex,
      stopActiveSelection: sourceVertex != null ? state.stopActiveSelection : StopActiveSelection.none,
    ));
  }

  void setTargetVertex(StopVertex? targetVertex) {
    emit(StopSelectState(
      sourceVertex: state.sourceVertex,
      dateTime: state.dateTime,
      targetVertex: targetVertex,
      stopActiveSelection: targetVertex != null ? state.stopActiveSelection : StopActiveSelection.none,
    ));
  }
}
