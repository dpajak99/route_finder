import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/vertex/vertex.dart';

class Edge<V extends Vertex> extends Equatable {
  final V sourceVertex;
  final V targetVertex;

  const Edge({
    required this.sourceVertex,
    required this.targetVertex,
  });

  @override
  List<Object?> get props => <Object>[sourceVertex, targetVertex];
}
