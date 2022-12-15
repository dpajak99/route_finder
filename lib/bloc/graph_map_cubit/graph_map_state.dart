import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';

abstract class GraphMapState extends Equatable {
  const GraphMapState();

  @override
  List<Object?> get props => <Object>[];
}

class GraphMapLoadingState extends GraphMapState {}

class GraphMapLoadedState extends GraphMapState {
  final List<TransitEdge> edges;
  final List<Marker> markers;

  const GraphMapLoadedState({
    required this.edges,
    required this.markers,
  });

  @override
  List<Object?> get props => <Object?>[edges, markers];
}

class GraphMapSearchState extends GraphMapLoadedState {
  const GraphMapSearchState({
    required List<TransitEdge> edges,
    required List<Marker> markers,
  }) : super(
          edges: edges,
          markers: markers,
        );
}
