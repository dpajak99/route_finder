import 'dart:math';

import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class VehicleEdge extends Edge {
  final StopVertex fromVertex;
  final StopVertex toVertex;
  final String trackId;
  final int timeFromNow;
  
  const VehicleEdge({
    required this.fromVertex,
    required this.toVertex,
    required this.trackId,
    required this.timeFromNow,
  }) : super();
  
  double calcCost() {
    return euclideanDistance();
  }
  
  double euclideanDistance() {
    return sqrt(pow(fromVertex.lat - toVertex.lat, 2) + pow(fromVertex.long - toVertex.long, 2));
  }
  
  @override
  List<Object?> get props => <Object?>[fromVertex, toVertex, trackId, timeFromNow];
}
