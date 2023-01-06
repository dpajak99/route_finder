import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge_cost_table/vehicle_edge_cost_table.dart';
import 'package:path_finder/utils/models/edge_cost_table/walk_edge_cost_table.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathfinderSearchRequest {
  final VehicleEdgeCostTable vehicleEdgeCostTable;
  final WalkEdgeCostTable walkEdgeCostTable;
  final MultiGraph<StopVertex, TransitEdge> graph;
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final DateTime startTime;

  PathfinderSearchRequest({
    required this.vehicleEdgeCostTable,
    required this.walkEdgeCostTable,
    required this.graph,
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
  });
}