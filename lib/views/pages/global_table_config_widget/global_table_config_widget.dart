import 'package:flutter/material.dart';
import 'package:math_parser/math_parser.dart';
import 'package:path_finder/utils/models/global_table_config_model.dart';
import 'package:path_finder/utils/models/walking_table_config_model.dart';
import 'package:path_finder/views/pages/global_table_config_widget/global_table_config_controller.dart';
import 'package:path_finder/views/pages/walking_table_config_widget/walking_table_config_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlobalTableConfigWidget extends StatefulWidget {
  final GlobalTableController globalTableController;
  final void Function() onChanged;

  const GlobalTableConfigWidget({
    required this.globalTableController,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _GlobalTableConfigWidgetState createState() => _GlobalTableConfigWidgetState();
}

class _GlobalTableConfigWidgetState extends State<GlobalTableConfigWidget> {
  @override
  void initState() {
    super.initState();
  }

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
                  child: TextField(
                    controller: widget.globalTableController.transitTimeWeightTextEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Waga czasu podróży',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: widget.globalTableController.distanceWeightTextEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Waga odległości',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => widget.globalTableController.resetValues(),
                    child: const Text('Resetuj'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onChanged,
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
  final WalkingTableController walkingTableController;

  const ChartDialog({
    required this.walkingTableController,
    Key? key,
  }) : super(key: key);

  @override
  _ChartDialogState createState() => _ChartDialogState();
}

class _ChartDialogState extends State<ChartDialog> {
  List<LineSeries<num, num>> lineSeries = <LineSeries<num, num>>[];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Wartość kary za przejście pieszo'),
      content: SizedBox(
        width: 900,
        height: 600,
        child: ValueListenableBuilder<WalkingTableConfigModel>(
          valueListenable: widget.walkingTableController.currentWalkingTableConfigModel,
          builder: (_, WalkingTableConfigModel walkingTableConfigModel, ___) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: SfCartesianChart(
                    legend: Legend(isVisible: true),
                    series: _getLineSeries(walkingTableConfigModel),
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
                          controller: widget.walkingTableController.penaltyFunctionTextEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Funkcja kary f(x) gdzie x to dystans',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.walkingTableController.guaranteedPenaltyTextEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Gwarantowana kara (a)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.walkingTableController.speedTextEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Średnia prędkość chodu (m/s)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: widget.walkingTableController.weightTextEditingController,
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

  List<LineSeries<num, num>> _getLineSeries(WalkingTableConfigModel walkingTableConfigModel) {
    return <LineSeries<num, num>>[
      LineSeries<num, num>(
        name: 'Wartość czasu pokonania odcinka',
        xAxisName: 'Metry',
        yAxisName: 'Minuty',
        dataSource: List<num>.generate(4, (int index) => index),
        xValueMapper: (num meters, _) => meters * 1000,
        yValueMapper: (num meters, _) => meters * 1000 / walkingTableConfigModel.speed,
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
              walkingTableConfigModel.penaltyFunction,
              variableNames: const <String>{'x', 'a'},
            ).calc(
              MathVariableValues(<String, num>{
                'x': meters * 10,
                'a': walkingTableConfigModel.guaranteedPenaltyForTransfer,
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
