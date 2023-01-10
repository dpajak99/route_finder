import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/vertex/vertex.dart';

class MultiGraph<V extends Vertex, E extends Edge<V>> {
  final Map<V, Map<V, List<E>>> adjacencyList = <V, Map<V, List<E>>>{};

  void addVertex(V vertex) {
    adjacencyList[vertex] = <V, List<E>>{};
  }

  void addVertexIterable(Iterable<V> vertices) {
    vertices.forEach(addVertex);
  }

  void addEdge(E vehicleEdge) {
    adjacencyList.putIfAbsent(vehicleEdge.sourceVertex, () => <V, List<E>>{});
    adjacencyList[vehicleEdge.sourceVertex]!.putIfAbsent(vehicleEdge.targetVertex, () => <E>[]);
    adjacencyList[vehicleEdge.sourceVertex]![vehicleEdge.targetVertex]!.add(vehicleEdge);
  }

  void addEdgeIterable(Iterable<E> vehicleEdges) {
    vehicleEdges.forEach(addEdge);
  }

  Map<V, List<E>> operator [](V vertex) => adjacencyList[vertex] ?? <V, List<E>>{};

  List<V> get keys => adjacencyList.keys.toList();

  List<E> get edges {
    final Set<E> result = <E>{};
    for (Map<V, List<E>> value in adjacencyList.values) {
      for (List<E> value in value.values) {
        result.addAll(value);
      }
    }
    return result.toList();
  }

  V get randomVertex {
    List<V> vertices = keys;
    vertices.shuffle();
    return vertices.first;
  }
}
