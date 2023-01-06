import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/bfs_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_result.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
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

  StopVertex vertex1 = StopVertex(id: '1', name: '1', latLng: LatLng(0, 0));
  StopVertex vertex2 = StopVertex(id: '2', name: '2', latLng: LatLng(0, 0));
  StopVertex vertex3 = StopVertex(id: '3', name: '3', latLng: LatLng(0, 0));
  StopVertex vertex4 = StopVertex(id: '4', name: '4', latLng: LatLng(0, 0));
  StopVertex vertex5 = StopVertex(id: '5', name: '5', latLng: LatLng(0, 0));
  StopVertex vertex6 = StopVertex(id: '6', name: '6', latLng: LatLng(0, 0));
  StopVertex vertex7 = StopVertex(id: '7', name: '7', latLng: LatLng(0, 0));
  StopVertex vertex8 = StopVertex(id: '8', name: '8', latLng: LatLng(0, 0));
  StopVertex vertex9 = StopVertex(id: '9', name: '9', latLng: LatLng(0, 0));
  StopVertex vertex10 = StopVertex(id: '10', name: '10', latLng: LatLng(0, 0));
  StopVertex vertex11 = StopVertex(id: '11', name: '11', latLng: LatLng(0, 0));

  MultiGraph<StopVertex, TransitEdge> graph = MultiGraph<StopVertex, TransitEdge>();

  // @formatter:off
  graph.addVertexIterable(<StopVertex>[vertex1, vertex2, vertex3, vertex4, vertex5, vertex6, vertex7, vertex8, vertex9, vertex10, vertex11]);
  // @formatter:on

  graph.addEdge(VehicleEdge(sourceVertex: vertex1, targetVertex: vertex2, trackId: '1', busName: '1', timeFromNow: 1, timeToNextStop: 1, departureTime: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertex1, targetVertex: vertex3, trackId: '1', busName: '1', timeFromNow: 1, timeToNextStop: 1, departureTime: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertex2, targetVertex: vertex4, trackId: '1', busName: '1', timeFromNow: 2, timeToNextStop: 1, departureTime: 2));
  graph.addEdge(VehicleEdge(sourceVertex: vertex2, targetVertex: vertex5, trackId: '1', busName: '1', timeFromNow: 1, timeToNextStop: 1, departureTime: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertex3, targetVertex: vertex6, trackId: '1', busName: '1', timeFromNow: 2, timeToNextStop: 1, departureTime: 2));
  graph.addEdge(VehicleEdge(sourceVertex: vertex4, targetVertex: vertex7, trackId: '1', busName: '1', timeFromNow: 3, timeToNextStop: 1, departureTime: 3));
  graph.addEdge(VehicleEdge(sourceVertex: vertex4, targetVertex: vertex8, trackId: '1', busName: '1', timeFromNow: 3, timeToNextStop: 1, departureTime: 3));
  graph.addEdge(VehicleEdge(sourceVertex: vertex5, targetVertex: vertex9, trackId: '1', busName: '1', timeFromNow: 3, timeToNextStop: 1, departureTime: 3));
  graph.addEdge(VehicleEdge(sourceVertex: vertex5, targetVertex: vertex10, trackId: '1', busName: '1', timeFromNow: 3, timeToNextStop: 1, departureTime: 3));
  graph.addEdge(VehicleEdge(sourceVertex: vertex6, targetVertex: vertex11, trackId: '1', busName: '1', timeFromNow: 3, timeToNextStop: 1, departureTime: 3));

  test('', () async {
    BfsPathfinderAlgorithm bfs = BfsPathfinderAlgorithm(graph: graph, sourceVertex: vertex1, targetVertex: vertex7, startTime: DateTime(2023));

    PathfinderResult pathSearchResult = await bfs.searchPath();

    for (EdgeDetails edgeDetails in pathSearchResult.path) {
      print('Edge: ${edgeDetails.transitEdge.sourceVertex.name} -> ${edgeDetails.transitEdge.targetVertex.name} | Time: ${edgeDetails.fullTime}');
    }
    print('-------------------');
    print(pathSearchResult.visitedStopsHistory.map((StopVertex e) => e.name));
  });

  test('', () async {
    BfsPathfinderAlgorithm bfs = BfsPathfinderAlgorithm(graph: graph, sourceVertex: vertex1, targetVertex: vertex9, startTime: DateTime(2023));

    expect(
      () async => bfs.searchPath(),
      throwsA(isA<Exception>()),
    );
  });
}