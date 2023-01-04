import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathfinderAlgorithmResult {
  final DateTime algorithmStartTime;
  final DateTime algorithmEndTime;
  final int visitedStopsCount;
  final Map<StopVertex, EdgeDetails> previous;
  final List<StopVertex> visitedStopsHistory;

  PathfinderAlgorithmResult({
    required this.algorithmStartTime,
    required this.algorithmEndTime,
    required this.visitedStopsCount,
    required this.previous,
    required this.visitedStopsHistory,
  });
}