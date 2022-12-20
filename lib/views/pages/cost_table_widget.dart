import 'package:flutter/material.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/utils/models/cost_config.dart';
import 'package:path_finder/utils/models/global_table_config_model.dart';
import 'package:path_finder/utils/models/ride_table_config_model.dart';
import 'package:path_finder/utils/models/walking_table_config_model.dart';
import 'package:path_finder/views/pages/global_table_config_widget/global_table_config_controller.dart';
import 'package:path_finder/views/pages/global_table_config_widget/global_table_config_widget.dart';
import 'package:path_finder/views/pages/ride_table_config_widget/ride_table_config_controller.dart';
import 'package:path_finder/views/pages/ride_table_config_widget/ride_table_config_widget.dart';
import 'package:path_finder/views/pages/walking_table_config_widget/walking_table_config_controller.dart';
import 'package:path_finder/views/pages/walking_table_config_widget/walking_table_config_widget.dart';

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
  late GlobalTableController globalTableController = GlobalTableController(
    initialGlobalTableConfigModel: widget.graphMapCubit.costConfig.globalTableConfigModel,
  );
  
  late RideTableController rideTableController = RideTableController(
    initialRideTableConfigModel: widget.graphMapCubit.costConfig.rideTableConfigModel,
  );
  
  late WalkingTableController walkingTableController = WalkingTableController(
    initialWalkingTableConfigModel: widget.graphMapCubit.costConfig.walkingTableConfigModel,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text('Konfiguracja kar globalnych'),
        GlobalTableConfigWidget(
          globalTableController: globalTableController,
          onChanged: () {
            globalTableController.save();
            rideTableController.save();
            walkingTableController.save();
            
            widget.graphMapCubit.costConfig.globalTableConfigModel = globalTableController.currentGlobalTableConfigModel.value;
            widget.graphMapCubit.search();
          },
        ),
        const SizedBox(height: 16),
        const Text('Konfiguracja kar pieszego transferu'),
        WalkingTableConfigWidget(
          walkingTableController: walkingTableController,
          onChanged: () {
            globalTableController.save();
            rideTableController.save();
            walkingTableController.save();
            
            widget.graphMapCubit.costConfig.walkingTableConfigModel = walkingTableController.currentWalkingTableConfigModel.value;
            widget.graphMapCubit.search();
            
          },
        ),
        const SizedBox(height: 16),
        const Text('Konfiguracja kar przejazdu'),
        RideTableConfigWidget(
          rideTableController: rideTableController,
          onChanged: () {
            globalTableController.save();
            rideTableController.save();
            walkingTableController.save();
            
            widget.graphMapCubit.costConfig.rideTableConfigModel = rideTableController.currentRideTableConfigModel.value;
            widget.graphMapCubit.search();
          },
        ),
      ],
    );
  }
}
