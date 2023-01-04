import 'package:flutter_test/flutter_test.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/dfs_pathfinder_algorithm.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

void main() {
  initLocator();

  ///              1
  ///          /      \
  ///        2         3
  ///      /   \       |
  ///     4    x5      6
  ///    / \   / \     |
  ///   7   8 9  10   11

  StopVertex vertex1 = const StopVertex(id: '1', name: '1', lat: 1, long: 1);
  StopVertex vertex2 = const StopVertex(id: '2', name: '2', lat: 2, long: 2);
  StopVertex vertex3 = const StopVertex(id: '3', name: '3', lat: 3, long: 3);
  StopVertex vertex4 = const StopVertex(id: '4', name: '4', lat: 4, long: 4);
  StopVertex vertex5 = const StopVertex(id: '5', name: '5', lat: 5, long: 5);
  StopVertex vertex6 = const StopVertex(id: '6', name: '6', lat: 6, long: 6);
  StopVertex vertex7 = const StopVertex(id: '7', name: '7', lat: 7, long: 7);
  StopVertex vertex8 = const StopVertex(id: '8', name: '8', lat: 8, long: 8);
  StopVertex vertex9 = const StopVertex(id: '9', name: '9', lat: 9, long: 9);
  StopVertex vertex10 = const StopVertex(id: '10', name: '10', lat: 10, long: 10);
  StopVertex vertex11 = const StopVertex(id: '11', name: '11', lat: 11, long: 11);

  StopsGraph stopsGraph = StopsGraph();

  // @formatter:off
  stopsGraph.addStops(<StopVertex>[vertex1, vertex2, vertex3, vertex4, vertex5, vertex6, vertex7, vertex8, vertex9, vertex10, vertex11]);
  // @formatter:on

  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex1, targetVertex: vertex2, trackId: '1', timeFromNow: 1, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex1, targetVertex: vertex3, trackId: '1', timeFromNow: 1, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex2, targetVertex: vertex4, trackId: '1', timeFromNow: 2, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex2, targetVertex: vertex5, trackId: '1', timeFromNow: 1, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex3, targetVertex: vertex6, trackId: '1', timeFromNow: 2, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex4, targetVertex: vertex7, trackId: '1', timeFromNow: 3, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex4, targetVertex: vertex8, trackId: '1', timeFromNow: 3, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex5, targetVertex: vertex9, trackId: '1', timeFromNow: 3, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex5, targetVertex: vertex10, trackId: '1', timeFromNow: 3, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertex6, targetVertex: vertex11, trackId: '1', timeFromNow: 3, timeToNextStop: 1));

  test('', () async {
    DfsPathfinderAlgorithm dfs = DfsPathfinderAlgorithm(stopsGraph: stopsGraph, sourceVertex: vertex1, targetVertex: vertex7, startTime: DateTime(2023));

    
    PathfinderResult pathSearchResult = await dfs.searchPath();
    
    for (EdgeDetails edgeDetails in pathSearchResult.path) {
      print('Edge: ${edgeDetails.transitEdge.sourceVertex.name} -> ${edgeDetails.transitEdge.targetVertex.name} | Time: ${edgeDetails.fullTime}');
    }
    print('-------------------');
    print(pathSearchResult.visitedStopsHistory.map((StopVertex e) => e.name));
  });

  test('', () {
    DfsPathfinderAlgorithm dfs = DfsPathfinderAlgorithm(stopsGraph: stopsGraph, sourceVertex: vertex1, targetVertex: vertex9, startTime: DateTime(2023));
    expect(
      () => dfs.searchPath(),
      throwsA(isA<Exception>()),
    );
  });
}