import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_result.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/dijkstra_pathfinder_algorithm.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

void main() {
  initLocator();

  ///                      6
  ///           - - > B - - > D _ _ _
  ///      1  /      | \      |      \  15
  ///       /        |   \ 7  |       \|
  ///    A         5 |     \  |  13    F
  ///       \       \/      \\/     /|
  ///      2 \ - - > C  - - > E - -/ 9
  ///                    6
  ///  

  StopVertex vertexA = StopVertex(id: 'A', name: 'A', latLng: LatLng(0, 0));
  StopVertex vertexB = StopVertex(id: 'B', name: 'B', latLng: LatLng(0, 0));
  StopVertex vertexC = StopVertex(id: 'C', name: 'C', latLng: LatLng(0, 0));
  StopVertex vertexD = StopVertex(id: 'D', name: 'D', latLng: LatLng(0, 0));
  StopVertex vertexE = StopVertex(id: 'E', name: 'E', latLng: LatLng(0, 0));
  StopVertex vertexF = StopVertex(id: 'F', name: 'F', latLng: LatLng(0, 0));

  MultiGraph<StopVertex, TransitEdge> graph = MultiGraph<StopVertex, TransitEdge>();

  // @formatter:off
  graph.addVertexIterable(<StopVertex>[vertexA, vertexB, vertexC, vertexD, vertexE, vertexF]);
  // @formatter:on

  graph.addEdge(VehicleEdge(sourceVertex: vertexA, targetVertex: vertexB, busName: '1', trackId: '1', timeFromNow: 2, departureTime: 2, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexA, targetVertex: vertexC, busName: '1', trackId: '1', timeFromNow: 1, departureTime: 1, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexB, targetVertex: vertexC, busName: '1', trackId: '1', timeFromNow: 5, departureTime: 5, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexB, targetVertex: vertexD, busName: '1', trackId: '1', timeFromNow: 6, departureTime: 6, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexC, targetVertex: vertexE, busName: '1', trackId: '1', timeFromNow: 6, departureTime: 6, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexD, targetVertex: vertexE, busName: '1', trackId: '1', timeFromNow: 7, departureTime: 7, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexD, targetVertex: vertexF, busName: '1', trackId: '1', timeFromNow: 15, departureTime: 15, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexE, targetVertex: vertexF, busName: '1', trackId: '1', timeFromNow: 9, departureTime: 9, timeToNextStop: 1));
  graph.addEdge(VehicleEdge(sourceVertex: vertexE, targetVertex: vertexB, busName: '1', trackId: '1', timeFromNow: 7, departureTime: 7, timeToNextStop: 1));


  test('', () async {
    DijkstraPathfinderAlgorithm dijkstra = DijkstraPathfinderAlgorithm(graph: graph, sourceVertex: vertexA, targetVertex: vertexF, startTime: DateTime(2023));

    
    PathfinderResult pathSearchResult = await dijkstra.searchPath();
    
    for (EdgeDetails edgeDetails in pathSearchResult.path) {
      print('Edge: ${edgeDetails.transitEdge.sourceVertex.name} -> ${edgeDetails.transitEdge.targetVertex.name} | Time: ${edgeDetails.fullTime}');
    }
    print('-------------------');
    print(pathSearchResult.visitedStopsHistory.map((StopVertex e) => e.name));
  });

  // test('', () {
  //   Dijkstra dijkstra = Dijkstra(stopsGraph: stopsGraph, sourceVertex: vertexA, targetVertex: vertexF, startTime: DateTime(2023));
  //   expect(
  //     () => dijkstra.searchPath(),
  //     throwsA(isA<Exception>()),
  //   );
  // });
}