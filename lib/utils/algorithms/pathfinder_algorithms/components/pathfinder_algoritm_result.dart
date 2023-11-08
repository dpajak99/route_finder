import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathfinderAlgorithmResult {
  final DateTime algorithmStartTime;
  final int visitedStopsCount;
  final Map<StopVertex, EdgeDetails> previous;
  final Map<StopVertex, double> costs;
  final Map<StopVertex, double> times;
  final List<StopVertex> visitedStopsHistory;

  PathfinderAlgorithmResult({
    required this.algorithmStartTime,
    required this.visitedStopsCount,
    required this.previous,
    required this.costs,
    required this.times,
    required this.visitedStopsHistory,
  });
}