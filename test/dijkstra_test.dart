import 'package:flutter_test/flutter_test.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/dijkstra_pathfinder_algorithm.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/pathfinder_result.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
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

  StopVertex vertexA = const StopVertex(id: 'A', name: 'A', lat: 1, long: 1);
  StopVertex vertexB = const StopVertex(id: 'B', name: 'B', lat: 2, long: 2);
  StopVertex vertexC = const StopVertex(id: 'C', name: 'C', lat: 3, long: 3);
  StopVertex vertexD = const StopVertex(id: 'D', name: 'D', lat: 4, long: 4);
  StopVertex vertexE = const StopVertex(id: 'E', name: 'E', lat: 5, long: 5);
  StopVertex vertexF = const StopVertex(id: 'F', name: 'F', lat: 6, long: 6);

  StopsGraph stopsGraph = StopsGraph();

  // @formatter:off
  stopsGraph.addStops(<StopVertex>[vertexA, vertexB, vertexC, vertexD, vertexE, vertexF]);
  // @formatter:on

  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexA, targetVertex: vertexB, trackId: '1', timeFromNow: 2, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexA, targetVertex: vertexC, trackId: '1', timeFromNow: 1, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexB, targetVertex: vertexC, trackId: '1', timeFromNow: 5, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexB, targetVertex: vertexD, trackId: '1', timeFromNow: 6, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexC, targetVertex: vertexE, trackId: '1', timeFromNow: 6, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexD, targetVertex: vertexE, trackId: '1', timeFromNow: 7, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexD, targetVertex: vertexF, trackId: '1', timeFromNow: 15, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexE, targetVertex: vertexF, trackId: '1', timeFromNow: 9, timeToNextStop: 1));
  stopsGraph.addEdge(VehicleEdge(sourceVertex: vertexE, targetVertex: vertexB, trackId: '1', timeFromNow: 7, timeToNextStop: 1));


  test('', () async {
    DijkstraPathfinderAlgorithm dijkstra = DijkstraPathfinderAlgorithm(stopsGraph: stopsGraph, sourceVertex: vertexA, targetVertex: vertexF, startTime: DateTime(2023));

    
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