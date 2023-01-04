import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/console_cubit/console_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopSelectCubit extends Cubit<StopSelectState> {
  final ConsoleCubit consoleCubit = getIt<ConsoleCubit>();

  StopSelectCubit() : super(const StopSelectState(stopActiveSelection: StopActiveSelection.none));
  
  void setActiveSelection(StopActiveSelection stopActiveSelection) {
    emit(state.copyWith(stopActiveSelection: stopActiveSelection));
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
    _setupConsole();
  }

  void setSourceVertex(StopVertex? sourceVertex) {
    emit(StopSelectState(
      sourceVertex: sourceVertex,
      targetVertex: state.targetVertex,
      stopActiveSelection: sourceVertex != null ? state.stopActiveSelection : StopActiveSelection.none,
    ));
    _setupConsole();
  }

  void setTargetVertex(StopVertex? targetVertex) {
    emit(StopSelectState(
      sourceVertex: state.sourceVertex,
      targetVertex: targetVertex,
      stopActiveSelection: targetVertex != null ? state.stopActiveSelection : StopActiveSelection.none,
    ));
    _setupConsole();
  }

  void _setupConsole() {
    consoleCubit.clear();
    consoleCubit.addLine('Source: ${state.sourceVertex?.name}');
    consoleCubit.addLine('Target: ${state.targetVertex?.name}');
  }
}
