import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_cost_table/edge_cost_table.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class TransitEdgeCostTable implements EdgeCostTable<StopVertex, TransitEdge> {
  final double transitTimeWeight;
  final double distanceWeight;

  TransitEdgeCostTable({
    required this.transitTimeWeight,
    required this.distanceWeight,
  });

  TransitEdgeCostTable copyWith({
    double? transitTimeWeight,
    double? distanceWeight,
  }) {
    return TransitEdgeCostTable(
      transitTimeWeight: transitTimeWeight ?? this.transitTimeWeight,
      distanceWeight: distanceWeight ?? this.distanceWeight,
    );
  }
  
  double calcCost(double transitTime, double distance) {
    return 0;
    // return transitTime * transitTimeWeight + distance * distanceWeight;
  }
}