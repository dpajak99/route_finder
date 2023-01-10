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

StopVertex vertexA = StopVertex(id: 'A', name: 'A', latLng: LatLng(50.010278, 20.986553));
StopVertex vertexB = StopVertex(id: 'B', name: 'B', latLng: LatLng(50.010653, 20.96977));
StopVertex vertexC = StopVertex(id: 'C', name: 'C', latLng: LatLng(50.007717, 20.971685));
StopVertex vertexD = StopVertex(id: 'D', name: 'D', latLng: LatLng(50.006462, 20.980616));
StopVertex vertexE = StopVertex(id: 'E', name: 'E', latLng: LatLng(50.008479, 20.981706));
StopVertex vertexF = StopVertex(id: 'F', name: 'F', latLng: LatLng(50.017273, 20.975667));
StopVertex vertexZ = StopVertex(id: 'Z', name: 'Z', latLng: LatLng(50.010278, 20.986553));

void main() {
  initLocator();

  MultiGraph<StopVertex, TransitEdge> graph = _mockGraph();


  test('', () async {
    BfsPathfinderAlgorithm bfs = BfsPathfinderAlgorithm(graph: graph, sourceVertex: vertexA, targetVertex: vertexZ, startTime: DateTime(2023));

    PathfinderResult pathSearchResult = await bfs.searchPath(stopWhetTarget: false);

    print('-------------------');
    print('BFS Test raport');
    print('-------------------');
    print('Visited edges history:');
    print(pathSearchResult.visitedStopsHistory.map((StopVertex e) => e.name));

    print('-------------------');
    print('Found path:');
    for (int i = 0; i < pathSearchResult.path.length; i++) {
      EdgeDetails edgeDetails = pathSearchResult.path[i];
      print('Step ${i + 1}: ${edgeDetails.transitEdge.sourceVertex.name} -> ${edgeDetails.transitEdge.targetVertex.name} | Time: ${edgeDetails.fullTime}');
    }
    print('-------------------');
    print('Total time: ${pathSearchResult.tripDuration}');
    print('-------------------');
  });
}

MultiGraph<StopVertex, TransitEdge> _mockGraph() {
  MultiGraph<StopVertex, TransitEdge> graph = MultiGraph<StopVertex, TransitEdge>();
  
  graph.addVertexIterable(<StopVertex>[vertexA, vertexB, vertexC, vertexD, vertexE, vertexF, vertexZ]);

  graph.addEdge(VehicleEdge(sourceVertex: vertexA, targetVertex: vertexB, trackId: '1', name: '1', timeFromNow: 0, timeToNextStop: 1, departureTime: 0, distanceInMeters: 250, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexA, targetVertex: vertexC, trackId: '1', name: '1', timeFromNow: 0, timeToNextStop: 5, departureTime: 0, distanceInMeters: 385, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexB, targetVertex: vertexE, trackId: '1', name: '1', timeFromNow: 1, timeToNextStop: 1, departureTime: 1, distanceInMeters: 880, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexB, targetVertex: vertexF, trackId: '1', name: '1', timeFromNow: 1, timeToNextStop: 5, departureTime: 1, distanceInMeters: 850, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexC, targetVertex: vertexD, trackId: '1', name: '1', timeFromNow: 5, timeToNextStop: 2, departureTime: 5, distanceInMeters: 660, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexC, targetVertex: vertexE, trackId: '1', name: '1', timeFromNow: 5, timeToNextStop: 1, departureTime: 5, distanceInMeters: 720, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexD, targetVertex: vertexE, trackId: '1', name: '1', timeFromNow: 7, timeToNextStop: 2, departureTime: 7, distanceInMeters: 240, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexE, targetVertex: vertexZ, trackId: '1', name: '1', timeFromNow: 9, timeToNextStop: 2, departureTime: 9, distanceInMeters: 400, polylines: const <String>[]));
  graph.addEdge(VehicleEdge(sourceVertex: vertexF, targetVertex: vertexZ, trackId: '1', name: '1', timeFromNow: 7, timeToNextStop: 1, departureTime: 7, distanceInMeters: 1100, polylines: const <String>[]));

  return graph;
}