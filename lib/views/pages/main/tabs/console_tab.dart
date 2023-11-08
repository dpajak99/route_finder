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
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromARGB(50, 33, 33, 33),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white10,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Console',
                style: TextStyle(
                  fontFamily: 'FiraCode',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: BlocBuilder<ConsoleCubit, ConsoleState>(
                bloc: consoleCubit,
                builder: (BuildContext context, ConsoleState state) {
                  return ListView.builder(
                    itemCount: state.consoleLines.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SelectableText(
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
            ),
          ),
        ],
      ),
    );
  }
}
