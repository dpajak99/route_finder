import 'package:equatable/equatable.dart';
import 'package:path_finder/views/models/geo_node.dart';
import 'package:path_finder/views/models/geo_node_heuristic.dart';

class AStarNodeWrapper {
  final GeoNode geoNode;
  final AStarNodeWrapper? parent;
  double h;
  double f;
  double g;

  AStarNodeWrapper({
    required this.geoNode,
    this.h = 0,
    this.f = 0,
    this.g = 0,
    this.parent,
  });
}
