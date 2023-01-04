import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class SearchRequest {
  final StopsGraph stopsGraph;
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final DateTime startTime;
  final Duration timeout;

  SearchRequest({
    required this.stopsGraph,
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
    required this.timeout,
  });
}