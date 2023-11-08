import 'package:equatable/equatable.dart';

class ConsoleState extends Equatable {
  final List<String> consoleLines;

  const ConsoleState({required this.consoleLines});
  
  @override
  List<Object> get props => <Object>[consoleLines];
}