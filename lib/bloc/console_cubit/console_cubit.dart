import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/console_cubit/console_state.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  ConsoleCubit() : super(const ConsoleState(consoleLines: <String>[]));

  void addLine(String line) {
    emit(ConsoleState(consoleLines: <String>[...state.consoleLines, line]));
  }
  
  void clear() {
    emit(const ConsoleState(consoleLines: <String>[]));
  }
  
  void setLines(List<String> lines) {
    emit(ConsoleState(consoleLines: lines));
  }
}