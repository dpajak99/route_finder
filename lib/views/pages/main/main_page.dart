import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/pathfinder_cubit/pathfinder_cubit.dart';
import 'package:path_finder/bloc/pathfinder_cubit/pathfinder_state.dart';
import 'package:path_finder/views/pages/main/tabs/console_tab.dart';
import 'package:path_finder/views/pages/main/tabs/header_tab.dart';
import 'package:path_finder/views/pages/main/tabs/settings_tab.dart';
import 'package:path_finder/views/pages/map/graph_map.dart';
import 'package:path_finder/views/widgets/generic/app_layout.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PathFinderCubit pathFinderCubit = PathFinderCubit();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PathFinderCubit, PathfinderState>(
      bloc: pathFinderCubit,
      builder: (BuildContext context, PathfinderState pathfinderState) {
        if( pathfinderState is PathfinderLoadingState ) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return AppLayout(
          header: const HeaderTab(),
          map: GraphMap(
            mapCubit: pathFinderCubit.mapCubit,
          ),
          menu: const SettingsTab(),
          console: ConsoleTab(),
        );
      },
    );
   
  }
}
