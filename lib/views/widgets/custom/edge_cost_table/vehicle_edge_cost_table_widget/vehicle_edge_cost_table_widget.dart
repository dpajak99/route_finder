import 'package:flutter/material.dart';
import 'package:path_finder/views/widgets/custom/edge_cost_table/vehicle_edge_cost_table_widget/vehicle_edge_cost_table_controller.dart';


class VehicleEdgeCostTableWidget extends StatefulWidget {
  const VehicleEdgeCostTableWidget({
    Key? key,
  }) : super(key: key);

  @override
  _VehicleEdgeCostTableWidgetState createState() => _VehicleEdgeCostTableWidgetState();
}

class _VehicleEdgeCostTableWidgetState extends State<VehicleEdgeCostTableWidget> {
  final VehicleEdgeCostTableController vehicleEdgeCostTableController = VehicleEdgeCostTableController();

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
                    controller: vehicleEdgeCostTableController.transferPenaltyTextEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Kara za transfer',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: vehicleEdgeCostTableController.penaltyWeightTextEditingController,
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
                Expanded(
                  child: TextField(
                    controller: vehicleEdgeCostTableController.waitingTimeWeightTextEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Waga czasu oczekiwania na transfer',
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
                    onPressed: vehicleEdgeCostTableController.resetValues,
                    child: const Text('Resetuj'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: vehicleEdgeCostTableController.save,
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