import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_parser/math_parser.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';
import 'package:path_finder/views/widgets/custom/edge_cost_table/walk_edge_cost_table_widget/walk_edge_cost_table_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WalkEdgeCostTableWidget extends StatefulWidget {
  const WalkEdgeCostTableWidget({
    Key? key,
  }) : super(key: key);

  @override
  _WalkEdgeCostTableWidgetState createState() => _WalkEdgeCostTableWidgetState();
}

class _WalkEdgeCostTableWidgetState extends State<WalkEdgeCostTableWidget> {
  final WalkEdgeCostTableController walkEdgeCostTableController = WalkEdgeCostTableController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: walkEdgeCostTableController.penaltyFunctionTextEditingController,
                    onSubmitted: (String value) => walkEdgeCostTableController.penaltyFunction = value,
                    decoration: const InputDecoration(
                      labelText: 'Funkcja kary f(x) gdzie x to dystans',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: walkEdgeCostTableController.guaranteedPenaltyTextEditingController,
                    onSubmitted: (String value) => walkEdgeCostTableController.guaranteedPenaltyForTransfer = double.parse(value),
                    decoration: const InputDecoration(
                      labelText: 'Gwarantowana kara (a)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: walkEdgeCostTableController.speedTextEditingController,
                    onSubmitted: (String value) => walkEdgeCostTableController.speed = int.parse(value),
                    decoration: const InputDecoration(
                      labelText: 'Średnia prędkość chodu (metrów/minuta)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: walkEdgeCostTableController.weightTextEditingController,
                    onSubmitted: (String value) => walkEdgeCostTableController.weight = int.parse(value),
                    decoration: const InputDecoration(
                      labelText: 'Waga',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showDialog<void>(context: context, builder: (_) => ChartDialog(walkEdgeCostTableController: walkEdgeCostTableController));
                  },
                  child: const Icon(Icons.search),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: walkEdgeCostTableController.resetValues,
                    child: const Text('Resetuj'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: walkEdgeCostTableController.save,
                    child: const Text('Zastosuj'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartDialog extends StatefulWidget {
  final WalkEdgeCostTableController walkEdgeCostTableController;

  const ChartDialog({
    required this.walkEdgeCostTableController,
    Key? key,
  }) : super(key: key);

  @override
  _ChartDialogState createState() => _ChartDialogState();
}

class _ChartDialogState extends State<ChartDialog> {
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
                          controller: widget.walkEdgeCostTableController.penaltyFunctionTextEditingController,
                          onSubmitted: (String value) => widget.walkEdgeCostTableController.penaltyFunction = value,
                          decoration: const InputDecoration(
                            labelText: 'Funkcja kary f(x) gdzie x to dystans',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.walkEdgeCostTableController.guaranteedPenaltyTextEditingController,
                          onSubmitted: (String value) => widget.walkEdgeCostTableController.guaranteedPenaltyForTransfer = double.parse(value),
                          decoration: const InputDecoration(
                            labelText: 'Gwarantowana kara (a)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.walkEdgeCostTableController.speedTextEditingController,
                          onSubmitted: (String value) => widget.walkEdgeCostTableController.speed = int.parse(value),
                          decoration: const InputDecoration(
                            labelText: 'Średnia prędkość chodu (m/s)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.walkEdgeCostTableController.weightTextEditingController,
                          onSubmitted: (String value) => widget.walkEdgeCostTableController.weight = int.parse(value),
                          decoration: const InputDecoration(
                            labelText: 'Waga',
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
