import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/console_cubit/console_cubit.dart';
import 'package:path_finder/bloc/map/map_cubit.dart';
import 'package:path_finder/bloc/pathfinder_cubit/pathfinder_state.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/service/graph_service.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/a_star_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/bfs_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/algorithm_type.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/dfs_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/dijkstra_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathFinderCubit extends Cubit<PathfinderState> {
  final ConsoleCubit consoleCubit = getIt<ConsoleCubit>();
  final MapCubit mapCubit = getIt<MapCubit>();
  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();
  final GraphService graphService = getIt<GraphService>();
  final StopService stopService = getIt<StopService>();
  
  PathFinderCubit() : super(PathfinderLoadingState()) {
    init();
  }
  
  Future<void> init() async {
    // run graph initialization to set cached repositories
    await graphService.getFullTransitsGraph(0);
    
    consoleCubit.setLines(<String>['Pathfinder v.1.0.0']);
    List<StopVertex> stopVertices = await stopService.getAll();
    mapCubit.setVisibleStops(stopVertices);
    
    emit(PathfinderLoadedState());
  }
  
  Future<void> search() async {
    DateTime now = DateTime.now();
    if(pathfinderSettingsCubit.state.filled == false ) {
      print('App not ready to search');
      return;
    }
    try {
      DateTime searchDatetime = pathfinderSettingsCubit.state.searchDateTime; 
      int minutes = searchDatetime.hour * 60 + searchDatetime.minute;
      MultiGraph<StopVertex, TransitEdge> graph = await graphService.getFullTransitsGraph(minutes);

      PathfinderAlgorithm pathfinderAlgorithm;
      switch (pathfinderSettingsCubit.state.algorithmType) {
        case AlgorithmType.dijkstra:
          pathfinderAlgorithm = DijkstraPathfinderAlgorithm(
            graph: graph,
            sourceVertex: pathfinderSettingsCubit.state.sourceVertex!,
            targetVertex: pathfinderSettingsCubit.state.targetVertex!,
            startTime: pathfinderSettingsCubit.state.searchDateTime,
          );
          break;
        case AlgorithmType.aStar:
          pathfinderAlgorithm = AStarPathfinderAlgorithm(
            graph: graph,
            sourceVertex: pathfinderSettingsCubit.state.sourceVertex!,
            targetVertex: pathfinderSettingsCubit.state.targetVertex!,
            startTime: pathfinderSettingsCubit.state.searchDateTime,
          );
          break;
        case AlgorithmType.dfs:
          pathfinderAlgorithm = DfsPathfinderAlgorithm(
            graph: graph,
            sourceVertex: pathfinderSettingsCubit.state.sourceVertex!,
            targetVertex: pathfinderSettingsCubit.state.targetVertex!,
            startTime: pathfinderSettingsCubit.state.searchDateTime,
          );
          break;
        case AlgorithmType.bfs:
          pathfinderAlgorithm = BfsPathfinderAlgorithm(
            graph: graph,
            sourceVertex: pathfinderSettingsCubit.state.sourceVertex!,
            targetVertex: pathfinderSettingsCubit.state.targetVertex!,
            startTime: pathfinderSettingsCubit.state.searchDateTime,
          );
          break;
        default:
          throw Exception('Algorithm not implemented');
      }

      DateTime now2 = DateTime.now();
      print('Time to get graph: ${now2.difference(now).inMilliseconds} ms');
      PathfinderResult pathfinderResult = await pathfinderAlgorithm.searchPath();
      mapCubit.setVisibleSearchResult(pathfinderResult);
      consoleCubit.setLines(pathfinderResult.logs);
    } catch(e) {
      consoleCubit.setLines(<String>['Error during search: ${e.runtimeType}']);
      rethrow;
    }
  }
}