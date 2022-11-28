import 'dart:math';

import 'package:path_finder/views/models/endpoint_pair.dart';
import 'package:path_finder/views/models/geo_node.dart';
import 'package:path_finder/views/models/value_graph.dart';

class GeoNodeHeuristic {
  late final double maxSpeed;
  late final GeoNode targetNode;

  GeoNodeHeuristic(ValueGraph<GeoNode, double> graph, this.targetNode) {
    maxSpeed = calculateMaxSpeed(graph);
  }

  static double calculateMaxSpeed(ValueGraph<GeoNode, double> graph) {
    return graph.edges.map((EndpointPair<GeoNode, double> edge) => calculateSpeed(graph, edge)).reduce((double a, double b) => a > b ? a : b);
  }

  static double calculateSpeed(ValueGraph<GeoNode, double> graph, EndpointPair<GeoNode, double> edge) {
    double euclideanDistance = calculateEuclideanDistance(edge.startNode, edge.endNode);
    double cost = edge.value;
    double speed = euclideanDistance / cost;
    return speed;
  }

  static double calculateEuclideanDistance(GeoNode source, GeoNode target) {
    double distanceX = target.lat - source.lat;
    double distanceY = target.long - source.long;
    return sqrt(distanceX * distanceX + distanceY * distanceY);
  }

  double apply(GeoNode node) {
    double euclideanDistance = calculateEuclideanDistance(node, targetNode);
    double minimumCost = euclideanDistance / maxSpeed;
    return minimumCost;
  }
}