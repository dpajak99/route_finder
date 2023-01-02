import 'package:path_finder/utils/models/edge_details.dart';

class TransitSearchPosition {
  final EdgeDetails? previousEdge;
  final double totalTimeFromStart;
  final double totalCostFromStart;

  TransitSearchPosition({
    required this.totalTimeFromStart,
    required this.totalCostFromStart,
    this.previousEdge,
  });
  
  bool get isFirstEdge =>  previousEdge == null;
}
