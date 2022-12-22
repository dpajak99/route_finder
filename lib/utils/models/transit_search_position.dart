import 'package:path_finder/utils/models/edge_result.dart';

class TransitSearchPosition {
  final TransitEdgeResult? previousTransitEdgeResult;
  final double totalTimeFromStart;

  TransitSearchPosition({
    required this.totalTimeFromStart,
    this.previousTransitEdgeResult,
  });
  
  bool get isFirstEdge =>  previousTransitEdgeResult == null;
}
