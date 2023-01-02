import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathSearchResult {
  final List<TransitEdgeResult> path;
  final List<StopVertex> visitedStopsHistory;

  PathSearchResult({
    required this.path,
    required this.visitedStopsHistory,
  });
}
