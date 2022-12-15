import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_state.dart';
import 'package:path_finder/views/pages/date_time_select.dart';
import 'package:path_finder/views/pages/stop_select.dart';

class SearchMenu extends StatefulWidget {
  final StopSelectCubit stopSelectCubit;
  final GraphMapCubit graphMapCubit;

  const SearchMenu({
    required this.stopSelectCubit,
    required this.graphMapCubit,
    super.key,
  });

  @override
  _SearchMenuState createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BlocBuilder<StopSelectCubit, StopSelectState>(
            bloc: widget.stopSelectCubit,
            builder: (BuildContext context, StopSelectState state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 8),
                  const Text('Wybierz przystanek początkowy'),
                  const SizedBox(height: 8),
                  StopSelect(
                    onTap: () {
                      widget.stopSelectCubit.setActiveSelection(StopActiveSelection.source);
                    },
                    onCancel: () {
                      widget.stopSelectCubit.setSourceVertex(null);
                    },
                    selectedVertex: state.sourceVertex,
                    active: state.stopActiveSelection == StopActiveSelection.source,
                  ),
                  const SizedBox(height: 16),
                  const Text('Wybierz przystanek końcowy'),
                  const SizedBox(height: 8),
                  StopSelect(
                    onTap: () {
                      widget.stopSelectCubit.setActiveSelection(StopActiveSelection.target);
                    },
                    onCancel: () {
                      widget.stopSelectCubit.setTargetVertex(null);
                    },
                    selectedVertex: state.targetVertex,
                    active: state.stopActiveSelection == StopActiveSelection.target,
                  ),
                  const SizedBox(height: 16),
                  const Text('Wybierz datę'),
                  const SizedBox(height: 8),
                  DateTimeSelect(
                      initialDateTime: state.dateTime,
                      onDateTimeChanged: (DateTime dateTime) {
                        widget.stopSelectCubit.setDateTime(dateTime);
                      }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isComplete
                          ? () {
                              widget.graphMapCubit.search(
                                source: state.sourceVertex!,
                                target: state.targetVertex!,
                                dateTime: state.dateTime,
                              );
                            }
                          : null,
                      child: const Text('Szukaj'),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
