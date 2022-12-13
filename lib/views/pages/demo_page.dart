import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_cubit.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_state.dart';
import 'package:path_finder/infra/entity/edge_entity.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/markers/stop_marker.dart';
import 'package:path_finder/utils/models/vertex/geo_vertex.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/views/pages/graph_map.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final GraphMapCubit graphMapCubit = GraphMapCubit();

  @override
  void initState() {
    super.initState();
    graphMapCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Row(
              children: const <Widget>[
                Text('Wybierz przewoźnika'),
              ],
            ),
          ),
          Expanded(
            child: GraphMap(
              graphMapCubit: graphMapCubit,
            ),
          ),
        ],
      ),
    );
  }
}
