import 'package:flutter/material.dart';
import 'package:path_finder/views/widgets/custom/edge_cost_table/edge_cost_table_controller.dart';
import 'package:path_finder/views/widgets/custom/edge_cost_table/edge_cost_table_dialog.dart';

class EdgeCostTableWidget extends StatefulWidget {
  const EdgeCostTableWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EdgeCostTableWidget createState() => _EdgeCostTableWidget();
}

class _EdgeCostTableWidget extends State<EdgeCostTableWidget> {
  final EdgeCostTableController edgeCostTableController = EdgeCostTableController();

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
                    controller: edgeCostTableController.penaltyFunctionTextEditingController,
                    onSubmitted: (String value) => edgeCostTableController.penaltyFunction = value,
                    decoration: const InputDecoration(
                      labelText: 'Funkcja kary f(x) gdzie x to dystans',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: edgeCostTableController.guaranteedPenaltyTextEditingController,
                    onSubmitted: (String value) => edgeCostTableController.guaranteedPenaltyForTransfer = double.parse(value),
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
                  child: TextField(
                    controller: edgeCostTableController.speedTextEditingController,
                    onSubmitted: (String value) => edgeCostTableController.speed = int.parse(value),
                    decoration: const InputDecoration(
                      labelText: 'Średnia prędkość chodu (metrów/minuta)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: edgeCostTableController.transferPenaltyTextEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Kara za transfer',
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
                    showDialog<void>(context: context, builder: (_) => EdgeCostTableDialog(edgeCostTableController: edgeCostTableController));
                  },
                  child: const Icon(Icons.search),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: edgeCostTableController.resetValues,
                    child: const Text('Resetuj'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: edgeCostTableController.save,
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
