import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_parser/math_parser.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';
import 'package:path_finder/views/widgets/custom/edge_cost_table/edge_cost_table_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EdgeCostTableDialog extends StatefulWidget {
  final EdgeCostTableController edgeCostTableController;

  const EdgeCostTableDialog({
    required this.edgeCostTableController,
    Key? key,
  }) : super(key: key);

  @override
  _EdgeCostTableDialog createState() => _EdgeCostTableDialog();
}

class _EdgeCostTableDialog extends State<EdgeCostTableDialog> {
  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();

  List<LineSeries<num, num>> lineSeries = <LineSeries<num, num>>[];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wartość kary za przejście pieszo'),
      content: SizedBox(
        width: 900,
        height: 600,
        child: BlocBuilder<PathfinderSettingsCubit, PathfinderSettingsState>(
          bloc: pathfinderSettingsCubit,
          builder: (BuildContext context, PathfinderSettingsState settings) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: SfCartesianChart(
                    legend: Legend(isVisible: true),
                    series: _getLineSeries(settings.walkEdgeCostTable),
                    tooltipBehavior: TooltipBehavior(enable: true),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: widget.edgeCostTableController.penaltyFunctionTextEditingController,
                          onSubmitted: (String value) => widget.edgeCostTableController.penaltyFunction = value,
                          decoration: const InputDecoration(
                            labelText: 'Funkcja kary f(x) gdzie x to dystans',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.edgeCostTableController.guaranteedPenaltyTextEditingController,
                          onSubmitted: (String value) => widget.edgeCostTableController.guaranteedPenaltyForTransfer = double.parse(value),
                          decoration: const InputDecoration(
                            labelText: 'Gwarantowana kara (a)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.edgeCostTableController.speedTextEditingController,
                          onSubmitted: (String value) => widget.edgeCostTableController.speed = int.parse(value),
                          decoration: const InputDecoration(
                            labelText: 'Średnia prędkość chodu (m/s)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.edgeCostTableController.transferPenaltyTextEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Kara za transfer',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Zamknij'),
        ),
      ],
    );
  }

  List<LineSeries<num, num>> _getLineSeries(WalkEdgeCostTable walkEdgeCostTable) {
    return <LineSeries<num, num>>[
      LineSeries<num, num>(
        name: 'Wartość czasu pokonania odcinka',
        xAxisName: 'Metry',
        yAxisName: 'Minuty',
        dataSource: List<num>.generate(4, (int index) => index),
        xValueMapper: (num meters, _) => meters * 1000,
        yValueMapper: (num meters, _) => meters * 1000 / walkEdgeCostTable.speed,
        width: 2,
        markerSettings: const MarkerSettings(),
      ),
      LineSeries<num, num>(
        name: 'Wartość kary za środek transportu',
        xAxisName: 'Metry',
        yAxisName: 'Minuty',
        dataSource: List<num>.generate(300, (int index) => index),
        xValueMapper: (num meters, _) => meters * 10,
        yValueMapper: (num meters, _) {
          try {
            return MathNodeExpression.fromString(
              walkEdgeCostTable.walkingDistancePenaltyFunction,
              variableNames: const <String>{'x', 'a'},
            ).calc(
              MathVariableValues(<String, num>{
                'x': meters * 10,
                'a': walkEdgeCostTable.guaranteedPenaltyForTransfer,
              }),
            );
          } catch (e) {
            return 0;
          }
        },
        width: 2,
        markerSettings: const MarkerSettings(),
      ),
    ];
  }
}