import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/map/map_cubit.dart';
import 'package:path_finder/bloc/pathfinder_cubit/pathfinder_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/views/pages/date_time_select.dart';
import 'package:path_finder/views/pages/stop_select.dart';
import 'package:path_finder/views/widgets/custom/algorithm_dropdown.dart';
import 'package:path_finder/views/widgets/custom/edge_cost_table/edge_cost_table_widget.dart';
import 'package:path_finder/views/widgets/generic/tab_layout.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();
  final PathFinderCubit pathFinderCubit = getIt<PathFinderCubit>();
  final StopSelectCubit stopSelectCubit = getIt<StopSelectCubit>();
  final MapCubit mapCubit = getIt<MapCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PathfinderSettingsCubit, PathfinderSettingsState>(
      bloc: pathfinderSettingsCubit,
      builder: (BuildContext context, PathfinderSettingsState settings) {
        return TabLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              const Text('Wybierz algorytm'),
              AlgorithmDropdown(
                initialValue: settings.algorithmType,
                onChanged: pathfinderSettingsCubit.setAlgorithmType,
              ),
              BlocConsumer<StopSelectCubit, StopSelectState>(
                bloc: stopSelectCubit,
                listener: (BuildContext context, StopSelectState stopSelectState) {
                  pathfinderSettingsCubit.setVertex(stopSelectState.sourceVertex, stopSelectState.targetVertex);
                },
                builder: (BuildContext context, StopSelectState stopSelectState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      const Text('Wybierz przystanek początkowy'),
                      StopSelect(
                        onTap: () => stopSelectCubit.setActiveSelection(StopActiveSelection.source),
                        onCancel: () => stopSelectCubit.setActiveSelection(StopActiveSelection.none),
                        onText: stopSelectCubit.setActiveSelectionById,
                        onRandom: stopSelectCubit.setRandomSourceVertex,
                        selectedVertex: stopSelectState.sourceVertex,
                        active: stopSelectState.stopActiveSelection == StopActiveSelection.source,
                      ),
                      TextButton.icon(
                        onPressed: stopSelectCubit.reverse,
                        icon: const Icon(Icons.swap_vert),
                        label: const Text('Zmień miejscami'),
                      ),
                      const SizedBox(height: 16),
                      const Text('Wybierz przystanek końcowy'),
                      StopSelect(
                        onTap: () => stopSelectCubit.setActiveSelection(StopActiveSelection.target),
                        onCancel: () => stopSelectCubit.setActiveSelection(StopActiveSelection.none),
                        onText: stopSelectCubit.setActiveSelectionById,
                        onRandom: stopSelectCubit.setRandomTargetVertex,
                        selectedVertex: stopSelectState.targetVertex,
                        active: stopSelectState.stopActiveSelection == StopActiveSelection.target,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text('Wybierz datę'),
              const SizedBox(height: 8),
              DateTimeSelect(
                initialDateTime: settings.searchDateTime,
                onDateTimeChanged: pathfinderSettingsCubit.setSearchDateTime,
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: pathFinderCubit.search,
                      child: const Text('Szukaj'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: mapCubit.reset,
                      child: const Text('Resetuj'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Konfiguracja kar'),
              const EdgeCostTableWidget(),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
