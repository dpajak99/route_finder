import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/queue/priority_queue.dart';
import 'package:path_finder/utils/models/transit_search_position.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/utils/transit_search_request.dart';

class Dijkstra {
  late StopsGraph _stopsGraph;
  late StopVertex _sourceVertex;
  late StopVertex _targetVertex;
  
  late PriorityQueue<StopVertex> _unvisitedStopsQueue;
  late Map<StopVertex, TransitEdgeResult> _visitedEdgesHistory;
  
  late Map<StopVertex, double> _times;
  late Map<StopVertex, double> _costs;

  List<TransitEdgeResult> search(TransitSearchRequest transitSearchRequest) {
    _setupInitialValues(transitSearchRequest);

    _unvisitedStopsQueue.add(_sourceVertex, 0);

    _times[_sourceVertex] = 0;
    _costs[_sourceVertex] = 0;

    while (_unvisitedStopsQueue.isNotEmpty) {
      PriorityQueueElement<StopVertex> currentQueueElement = _unvisitedStopsQueue.pop();
      StopVertex currentStopVertex = currentQueueElement.value;
      double distanceFromSourceVertex = currentQueueElement.priority;
      
      TransitEdgeResult? previousEdgeResult = _visitedEdgesHistory[currentStopVertex];

      double totalTimeFromStart = _times[currentStopVertex] ?? 0;
      double totalCostFromStart = _costs[currentStopVertex] ?? 0;

      
      TransitSearchPosition transitSearchPosition = TransitSearchPosition(
        totalTimeFromStart: totalTimeFromStart,
        previousTransitEdgeResult: previousEdgeResult,
      );
      

      List<TransitEdge> neighbors = _stopsGraph[currentStopVertex] ?? List<TransitEdge>.empty();
      if(transitSearchPosition.isFirstEdge) {
        for(TransitEdge edge in neighbors) {
          if(edge is WalkEdge) {
            print(edge);
          }
        }
      }
      for (TransitEdge neighborEdge in neighbors) {
        bool isTransitAvailable = neighborEdge.canReachEdge(transitSearchPosition);
        if (isTransitAvailable == false) {
          continue;
        }

        StopVertex neighborVertex = neighborEdge.targetVertex;
        double edgeCost = neighborEdge.calcCost(transitSearchPosition);

        FullEdgeTime fullEdgeTime = neighborEdge.calcTime(transitSearchPosition);

        double timeFromStartToReachNeighbor = totalTimeFromStart + fullEdgeTime.total;

        double costFromStartToReachNeighbor = totalCostFromStart + edgeCost;

        double previousTotalCostWithNeighbor = _costs[neighborVertex] ?? double.infinity;

        bool hasBetterCost = costFromStartToReachNeighbor < previousTotalCostWithNeighbor;
        bool firstNeighborVisit = _costs[neighborVertex] == null;

        if (firstNeighborVisit || hasBetterCost) {
          // Update the previous vertex for the selected vertex
          _visitedEdgesHistory[neighborVertex] = TransitEdgeResult(
            transitEdge: neighborEdge,
            transitSearchRequest: transitSearchRequest,
            edgeCost: edgeCost,
            edgeTimeStart: totalTimeFromStart,
            fullEdgeTime: fullEdgeTime,
            edgeTimeEnd: timeFromStartToReachNeighbor,
          );

          // Update the distance from the start vertex for the selected vertex
          _times[neighborVertex] = timeFromStartToReachNeighbor;
          _costs[neighborVertex] = costFromStartToReachNeighbor;

          _unvisitedStopsQueue.add(neighborVertex, costFromStartToReachNeighbor);
        }
      }
    }

    if (_costs[_targetVertex] == null) {
      throw Exception('Cannot find path from ${_sourceVertex.id} to ${_targetVertex.id}');
    }



    List<TransitEdgeResult> path = _buildPath();
    _printPath(path);
    
    return path.reversed.toList();
  }
  
  void _setupInitialValues(TransitSearchRequest transitSearchRequest) {
    _stopsGraph = transitSearchRequest.stopsGraph;
    _sourceVertex = transitSearchRequest.sourceVertex;
    _targetVertex = transitSearchRequest.targetVertex;

    // Priority queue to select the next vertex to visit
    // based on the distance from the start vertex
    _unvisitedStopsQueue = PriorityQueue<StopVertex>();


    // Map to store the previous vertex for each vertex
    // in the shortest path from the start vertex
    _visitedEdgesHistory = <StopVertex, TransitEdgeResult>{};

    // Map to store the distance from the start vertex for each vertex
    // Map<StopVertex, double> distances = <StopVertex, double>{};
    _times = <StopVertex, double>{};
    _costs = <StopVertex, double>{};
  }
  
  List<TransitEdgeResult> _buildPath() {
    // List to store the vertices in the shortest path
    List<TransitEdgeResult> path = <TransitEdgeResult>[];

    // Start from the end vertex and follow the previous pointers
    // back to the start vertex, adding each visited vertex to the list

    StopVertex currentVertex = _targetVertex;
    while (currentVertex != _sourceVertex) {
      TransitEdgeResult? currentEdge = _visitedEdgesHistory[currentVertex]!;
      path.add(currentEdge);
      currentVertex = currentEdge.transitEdge.sourceVertex;
    }
    
    return path;
  }
  
  void _printPath(List<TransitEdgeResult> path) {
    for (TransitEdgeResult edgeResult in path.reversed) {
      print(edgeResult);
    }
  }
}
