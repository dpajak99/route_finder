import 'package:flutter/material.dart';
import 'package:path_finder/views/widgets/edge_cost_table/transit_edge_cost_table_widget/transit_edge_cost_table_controller.dart';

class TransitEdgeCostTableWidget extends StatefulWidget {
  const TransitEdgeCostTableWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TransitEdgeCostTableWidgetState createState() => _TransitEdgeCostTableWidgetState();
}

class _TransitEdgeCostTableWidgetState extends State<TransitEdgeCostTableWidget> {
  final TransitEdgeCostTableController transitEdgeCostTableController = TransitEdgeCostTableController();
  
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
                    controller: transitEdgeCostTableController.transitTimeWeightTextEditingController,
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
                    controller: transitEdgeCostTableController.distanceWeightTextEditingController,
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
                    onPressed: transitEdgeCostTableController.resetValues,
                    child: const Text('Resetuj'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: transitEdgeCostTableController.save,
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