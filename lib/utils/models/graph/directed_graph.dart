import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/vertex/vertex.dart';

class DirectedGraph<V extends Vertex, E extends Edge<V>> {
  final Map<V, List<E>> adjacencyList = <V, List<E>>{};

  void addVertex(V vertex) {
    adjacencyList[vertex] = <E>[];
  }

  void addVertexIterable(Iterable<V> vertices) {
    vertices.forEach(addVertex);
  }

  void addEdge(E vehicleEdge) {
    adjacencyList[vehicleEdge.sourceVertex]!.add(vehicleEdge);
  }

  void addEdgeIterable(Iterable<E> vehicleEdges) {
    vehicleEdges.forEach(addEdge);
  }

  List<E> operator [](V vertex) => adjacencyList[vertex] ?? <E>[];

  List<V> get keys => adjacencyList.keys.toList();

  List<E> get values => adjacencyList.values.toList().reduce((List<E> value, List<E> element) => value + element);
}
