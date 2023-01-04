import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_finder/bloc/map/map_cubit.dart';
import 'package:path_finder/bloc/pathfinder_cubit/pathfinder_state.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/service/edge_service.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/algorithms/a_star.dart';
import 'package:path_finder/utils/algorithms/algorithm_type.dart';
import 'package:path_finder/utils/algorithms/dijkstra.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithm.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/pathfinder_result.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathFinderCubit extends Cubit<PathfinderState> {
  final MapCubit mapCubit = getIt<MapCubit>();
  final PathfinderSettingsCubit pathfinderSettingsCubit = getIt<PathfinderSettingsCubit>();
  final StopService _stopService = StopService();
  final EdgeService _edgeService = EdgeService();
  
  PathFinderCubit() : super(PathfinderLoadingState()) {
    init();
  }
  
  Future<void> init() async {
    List<StopVertex> stopVertexList = await _stopService.getVertexList();
    StopsGraph stopsGraph = StopsGraph();
    stopsGraph.addStops(stopVertexList);

    mapCubit.setVisibleStops(stopVertexList);
    
    emit(PathfinderLoadedState());
  }
  
  Future<void> search() async {
    if(pathfinderSettingsCubit.state.filled == false ) {
      print('App not ready to search');
      return;
    }
    List<StopVertex> stopVertexList = await _stopService.getVertexList();
    List<VehicleEdge> edges = await _edgeService.getEdgesList(stopVertexList, pathfinderSettingsCubit.state.searchDateTime);
    StopsGraph stopsGraph = StopsGraph();
    stopsGraph.addStops(stopVertexList);
    stopsGraph.addEdgeIterable(edges);
    
    PathfinderAlgorithm pathfinderAlgorithm;
    switch (pathfinderSettingsCubit.state.algorithmType) {
      case AlgorithmType.dijkstra:
        pathfinderAlgorithm = Dijkstra(
            stopsGraph: stopsGraph, 
            sourceVertex: pathfinderSettingsCubit.state.sourceVertex!,
            targetVertex: pathfinderSettingsCubit.state.targetVertex!,
            startTime: pathfinderSettingsCubit.state.searchDateTime,
        );
        break;
      case AlgorithmType.aStar:
        pathfinderAlgorithm = AStar(
          stopsGraph: stopsGraph,
          sourceVertex: pathfinderSettingsCubit.state.sourceVertex!,
          targetVertex: pathfinderSettingsCubit.state.targetVertex!,
          startTime: pathfinderSettingsCubit.state.searchDateTime,
        );
        break;
      default:
        throw Exception('Algorithm not implemented');
    }
    
    PathfinderResult pathfinderResult = await pathfinderAlgorithm.searchPath();
    mapCubit.setVisibleSearchResult(pathfinderResult);
  }
}