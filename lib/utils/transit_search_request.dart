import 'package:path_finder/utils/models/graph/stops_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class TransitSearchRequest {
  final StopsGraph stopsGraph;
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final int startTime;

  TransitSearchRequest({
    required this.stopsGraph,
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
  });
}
