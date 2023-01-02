import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/path_search_result.dart';
import 'package:path_finder/utils/models/queue/priority_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/utils/transit_search_request.dart';

class Bfs {
  final Map<StopVertex, double> _times = <StopVertex, double>{};
  final Map<StopVertex, double> _costs = <StopVertex, double>{};

  // Funkcja znajdująca ścieżkę między dwoma wierzchołkami za pomocą algorytmu BFS
  PathSearchResult search(TransitSearchRequest transitSearchRequest) {
    StopsGraph stopsGraph = transitSearchRequest.stopsGraph;
    StopVertex sourceVertex = transitSearchRequest.sourceVertex;
    StopVertex targetVertex = transitSearchRequest.targetVertex;

    // Lista przechowująca odwiedzone wierzchołki
    List<TransitEdge> visited = List<TransitEdge>.empty(growable: true);

    // Kolejka przechowująca wierzchołki do odwiedzenia
    PriorityQueue<StopVertex> unvisitedStopsQueue = PriorityQueue<StopVertex>();

    // Mapa przechowująca informacje o poprzednikach dla każdego wierzchołka
    Map<StopVertex, TransitEdgeResult> visitedEdgesHistory = <StopVertex, TransitEdgeResult>{};
    List<StopVertex> visitedStopsHistory = List<StopVertex>.empty(growable: true);

    unvisitedStopsQueue.add(sourceVertex, 0);
    // visited.add(sourceVertex);

    while (unvisitedStopsQueue.isNotEmpty) {
      PriorityQueueElement<StopVertex> currentQueueElement = unvisitedStopsQueue.pop();
      StopVertex currentStopVertex = currentQueueElement.value;
      visitedStopsHistory.add(currentStopVertex);

      TransitEdgeResult? previousEdgeResult = visitedEdgesHistory[currentStopVertex];
      double totalTimeFromStart = _times[currentStopVertex] ?? 0;
      double totalCostFromStart = _costs[currentStopVertex] ?? 0;

      TransitSearchPosition transitSearchPosition = TransitSearchPosition(
        totalTimeFromStart: totalTimeFromStart,
        previousTransitEdgeResult: previousEdgeResult,
      );

      if (currentStopVertex == targetVertex) {
        break;
      }
      List<TransitEdge> neighbors = stopsGraph[currentStopVertex] ?? List<TransitEdge>.empty();
      for (TransitEdge neighborEdge in neighbors) {
        bool isTransitAvailable = neighborEdge.canReachEdge(transitSearchPosition);
        if (isTransitAvailable == false) {
          continue;
        }
        StopVertex neighborVertex = neighborEdge.targetVertex;

        if (!visited.contains(neighborEdge)) {
          FullEdgeTime fullEdgeTime = neighborEdge.calcTime(transitSearchPosition);
          double edgeCost = neighborEdge.calcCost(transitSearchPosition);
          double timeFromStartToReachNeighbor = totalTimeFromStart + fullEdgeTime.total;

          double costFromStartToReachNeighbor = totalCostFromStart + edgeCost;

          visited.add(neighborEdge);
          unvisitedStopsQueue.add(neighborEdge.targetVertex, costFromStartToReachNeighbor);
          visitedEdgesHistory[neighborEdge.targetVertex] = TransitEdgeResult(
            transitEdge: neighborEdge,
            transitSearchRequest: transitSearchRequest,
            edgeCost: edgeCost,
            edgeTimeStart: totalTimeFromStart,
            fullEdgeTime: fullEdgeTime,
            edgeTimeEnd: timeFromStartToReachNeighbor,
          );

          _times[neighborVertex] = timeFromStartToReachNeighbor;
          _costs[neighborVertex] = costFromStartToReachNeighbor;
        }
      }
    }

    // Jeśli nie znaleziono ścieżki, zwracamy pustą listę
    if (!visitedEdgesHistory.containsKey(targetVertex)) {
      throw Exception('Cannot find path from ${sourceVertex.id} to ${targetVertex.id}');
    }

    // List to store the vertices in the shortest path
    List<TransitEdgeResult> path = <TransitEdgeResult>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list

    StopVertex currentVertex = targetVertex;
    while (currentVertex != sourceVertex) {
      TransitEdgeResult currentEdge = visitedEdgesHistory[currentVertex]!;
      path.add(currentEdge);
      currentVertex = currentEdge.transitEdge.sourceVertex;
    }
    return PathSearchResult(
      path: path.reversed.toList(),
      visitedStopsHistory: visitedStopsHistory,
    );
  }
}
