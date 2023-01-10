import 'package:flutter/material.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/infra/service/graph_service.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/a_star_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/bfs_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/dfs_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/dijkstra_pathfinder_algorithm.dart';
import 'package:path_finder/utils/file_utils.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLocator();

  GraphService graphService = getIt<GraphService>();
  DateTime dateTime = DateTime(2022, 12, 15, 6, 0);
  int startTime = dateTime.hour * 60 + dateTime.minute;

  MultiGraph<StopVertex, TransitEdge> graph = await graphService.getFullTransitsGraph(startTime);

  List<String> dijkstraResults = <String>[];
  List<String> aStarResults = <String>[];
  List<String> bfsResults = <String>[];
  List<String> dfsResults = <String>[];

  dijkstraResults.add('LP;FROM;TO;VISITED;WALKS;TRANSFERS;WALK_DISTANCE;TRIP_DISTANCE;TRIP_DURATION;SEARCH_DURATION');
  aStarResults.add('LP;FROM;TO;VISITED;WALKS;TRANSFERS;WALK_DISTANCE;TRIP_DISTANCE;TRIP_DURATION;SEARCH_DURATION');
  bfsResults.add('LP;FROM;TO;VISITED;WALKS;TRANSFERS;WALK_DISTANCE;TRIP_DISTANCE;TRIP_DURATION;SEARCH_DURATION');
  dfsResults.add('LP;FROM;TO;VISITED;WALKS;TRANSFERS;WALK_DISTANCE;TRIP_DISTANCE;TRIP_DURATION;SEARCH_DURATION');

  for (int i = 0; i < 1000; i++) {
    print(i);
    StopVertex sourceVertex = graph.randomVertex;
    StopVertex targetVertex = graph.randomVertex;

    DijkstraPathfinderAlgorithm dijkstra =
        DijkstraPathfinderAlgorithm(graph: graph, sourceVertex: sourceVertex, targetVertex: targetVertex, startTime: dateTime);
    AStarPathfinderAlgorithm aStar = AStarPathfinderAlgorithm(graph: graph, sourceVertex: sourceVertex, targetVertex: targetVertex, startTime: dateTime);
    BfsPathfinderAlgorithm bfs = BfsPathfinderAlgorithm(graph: graph, sourceVertex: sourceVertex, targetVertex: targetVertex, startTime: dateTime);
    DfsPathfinderAlgorithm dfs = DfsPathfinderAlgorithm(graph: graph, sourceVertex: sourceVertex, targetVertex: targetVertex, startTime: dateTime);

    PathfinderResult? dijkstraResult;
    PathfinderResult? aStarResult;
    PathfinderResult? bfsResult;
    PathfinderResult? dfsResult;

    try {
      dijkstraResult = await dijkstra.searchPath();
    } catch (e) {
      print('Dijkstra for ${sourceVertex.id} -> ${targetVertex.id} failed');
    }

    try {
      aStarResult = await aStar.searchPath();
    } catch (e) {
      print('A* for ${sourceVertex.id} -> ${targetVertex.id} failed');
    }

    try {
      bfsResult = await bfs.searchPath();
    } catch (e) {
      print('BFS for ${sourceVertex.id} -> ${targetVertex.id} failed');
    }

    try {
      dfsResult = await dfs.searchPath();
    } catch (e) {
      print('DFS for ${sourceVertex.id} -> ${targetVertex.id} failed');
    }

    dijkstraResults.add(_prepareCsvResult(i + 1, sourceVertex, targetVertex, dijkstraResult));
    aStarResults.add(_prepareCsvResult(i + 1, sourceVertex, targetVertex, aStarResult));
    bfsResults.add(_prepareCsvResult(i + 1, sourceVertex, targetVertex, bfsResult));
    dfsResults.add(_prepareCsvResult(i + 1, sourceVertex, targetVertex, dfsResult));

    await FileUtils.writeLocalFile('result_dijkstra.csv', dijkstraResults.join('\n'));
    await FileUtils.writeLocalFile('result_a_star.csv', aStarResults.join('\n'));
    await FileUtils.writeLocalFile('result_bfs.csv', bfsResults.join('\n'));
    await FileUtils.writeLocalFile('result_dfs.csv', dfsResults.join('\n'));
  }
}

String _prepareCsvResult(int lp, StopVertex sourceVertex, StopVertex targetVertex, PathfinderResult? pathfinderResult) {
  String lpText = lp.toString();
  String from = sourceVertex.id;
  String to = targetVertex.id;
  String visitedStops = pathfinderResult?.visitedStopsCount.toString() ?? '';
  String walks = pathfinderResult?.totalWalksCount.toString() ?? '';
  String transfers = pathfinderResult?.totalTransfersCount.toString() ?? '';
  String walkDistance = pathfinderResult?.totalWalkDistance.inMeters.toString() ?? '';
  String tripDistance = pathfinderResult?.totalTripDistance.inMeters.toString() ?? '';
  String tripDuration = pathfinderResult?.tripDuration.inMinutes.toString() ?? '';
  String searchDuration = pathfinderResult?.searchDuration.inMilliseconds.toString() ?? '';

  String result = '$lpText;$from;$to;$visitedStops;$walks;$transfers;$walkDistance;$tripDistance;$tripDuration;$searchDuration';
  return result;
}
