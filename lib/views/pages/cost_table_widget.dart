import 'package:flutter/material.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_cubit.dart';
import 'package:path_finder/views/widgets/edge_cost_table/transit_edge_cost_table_widget/transit_edge_cost_table_widget.dart';
import 'package:path_finder/views/widgets/edge_cost_table/vehicle_edge_cost_table_widget/vehicle_edge_cost_table_widget.dart';
import 'package:path_finder/views/widgets/edge_cost_table/walk_edge_cost_table_widget/walk_edge_cost_table_widget.dart';

class CostTableWidget extends StatefulWidget {
  final GraphMapCubit graphMapCubit;

  const CostTableWidget({
    required this.graphMapCubit,
    Key? key,
  }) : super(key: key);

  @override
  _CostTableWidgetState createState() => _CostTableWidgetState();
}

class _CostTableWidgetState extends State<CostTableWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        Text('Konfiguracja kar globalnych'),
        TransitEdgeCostTableWidget(),
        SizedBox(height: 16),
        Text('Konfiguracja kar pieszego transferu'),
        WalkEdgeCostTableWidget(),
        SizedBox(height: 16),
        Text('Konfiguracja kar przejazdu'),
        VehicleEdgeCostTableWidget(),
      ],
    );
  }
}
