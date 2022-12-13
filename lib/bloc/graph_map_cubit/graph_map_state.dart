import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/directed_graph.dart';
import 'package:path_finder/utils/models/vertex/geo_vertex.dart';

abstract class GraphMapState extends Equatable {
  const GraphMapState();
  @override
  List<Object?> get props => <Object>[];
}

class GraphMapLoadingState extends GraphMapState {}

class GraphMapLoadedState extends GraphMapState {
  final DirectedGraph directedGraph;
  final List<GeoVertex> vertices;


  const GraphMapLoadedState({
    required this.directedGraph,
    required this.vertices,
  });

  @override
  List<Object?> get props => <Object?>[directedGraph, vertices];
}