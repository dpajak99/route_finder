import 'package:flutter/material.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_cubit.dart';
import 'package:path_finder/views/layout/app_layout.dart';
import 'package:path_finder/views/pages/graph_map.dart';
import 'package:path_finder/views/pages/search_menu.dart';

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
    return AppLayout(
      header: Row(
        children: const <Widget>[
          Text('Wybierz przewoźnika'),
        ],
      ),
      map: GraphMap(
        graphMapCubit: graphMapCubit,
      ),
      menu: SearchMenu(
        graphMapCubit: graphMapCubit,
      ),
      terminal: Column(
        children: const <Widget>[
          Text('Wybierz przewoźnika'),
        ],
      ),
    );
  }
}
