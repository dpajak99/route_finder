import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_cubit.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_state.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_state.dart';
import 'package:path_finder/views/pages/algorithm_dropdown.dart';
import 'package:path_finder/views/pages/cost_table_widget.dart';
import 'package:path_finder/views/pages/date_time_select.dart';
import 'package:path_finder/views/pages/stop_select.dart';

class SearchMenu extends StatefulWidget {
  final GraphMapCubit graphMapCubit;

  const SearchMenu({
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
          const SizedBox(height: 8),
          const Text('Wybierz algorytm'),
          const SizedBox(height: 8),
          const AlgorithmDropdown(),
          const SizedBox(height: 16),
          BlocBuilder<GraphMapCubit, GraphMapState>(
            bloc: widget.graphMapCubit,
            builder: (BuildContext context, GraphMapState graphMapState) {
              return BlocBuilder<StopSelectCubit, StopSelectState>(
                bloc: widget.graphMapCubit.stopSelectCubit,
                builder: (BuildContext context, StopSelectState stopSelectState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Wybierz przystanek początkowy'),
                      const SizedBox(height: 8),
                      StopSelect(
                        onTap: () {
                          widget.graphMapCubit.stopSelectCubit.setActiveSelection(StopActiveSelection.source);
                        },
                        onCancel: () {
                          widget.graphMapCubit.stopSelectCubit.setSourceVertex(null);
                        },
                        selectedVertex: stopSelectState.sourceVertex,
                        active: stopSelectState.stopActiveSelection == StopActiveSelection.source,
                      ),
                      const SizedBox(height: 16),
                      const Text('Wybierz przystanek końcowy'),
                      const SizedBox(height: 8),
                      StopSelect(
                        onTap: () {
                          widget.graphMapCubit.stopSelectCubit.setActiveSelection(StopActiveSelection.target);
                        },
                        onCancel: () {
                          widget.graphMapCubit.stopSelectCubit.setTargetVertex(null);
                        },
                        selectedVertex: stopSelectState.targetVertex,
                        active: stopSelectState.stopActiveSelection == StopActiveSelection.target,
                      ),
                      const SizedBox(height: 16),
                      const Text('Wybierz datę'),
                      const SizedBox(height: 8),
                      DateTimeSelect(
                          initialDateTime: stopSelectState.dateTime,
                          onDateTimeChanged: (DateTime dateTime) {
                            widget.graphMapCubit.stopSelectCubit.setDateTime(dateTime);
                          }),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: stopSelectState.isComplete ? () => widget.graphMapCubit.search() : null,
                              child: const Text('Szukaj'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: graphMapState is GraphMapSearchState ? () => widget.graphMapCubit.init() : null,
                              child: const Text('Resetuj'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CostTableWidget(graphMapCubit: widget.graphMapCubit,),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
