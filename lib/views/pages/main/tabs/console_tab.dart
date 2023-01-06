import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/console_cubit/console_cubit.dart';
import 'package:path_finder/bloc/console_cubit/console_state.dart';
import 'package:path_finder/config/locator.dart';

class ConsoleTab extends StatelessWidget {
  final ConsoleCubit consoleCubit = getIt<ConsoleCubit>();

  ConsoleTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 43, 43, 43),
      ),
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<ConsoleCubit, ConsoleState>(
        bloc: consoleCubit,
        builder: (BuildContext context, ConsoleState state) {
          return ListView.builder(
            itemCount: state.consoleLines.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                '> ${state.consoleLines[index]}',
                style: const TextStyle(
                  fontFamily: 'FiraCode',
                  color: Colors.white,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
