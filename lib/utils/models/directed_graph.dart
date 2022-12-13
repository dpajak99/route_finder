import 'package:path_finder/utils/models/edge/edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/vertex/vertex.dart';

class DirectedGraph {
  final Map<Vertex, List<VehicleEdge>> adjacencyList = <Vertex, List<VehicleEdge>>{};

  void addVertex(Vertex vertex) {
    adjacencyList[vertex] = <VehicleEdge>[];
  }

  void addVertexIterable(Iterable<Vertex> vertices) {
    vertices.forEach(addVertex);
  }

  void addEdge(VehicleEdge vehicleEdge) {
    adjacencyList[vehicleEdge.fromVertex]!.add(vehicleEdge);
  }

  void addEdgeIterable(Iterable<VehicleEdge> vehicleEdges) {
    vehicleEdges.forEach(addEdge);
  }

  List<VehicleEdge>? operator [](Vertex vertex) => adjacencyList[vertex];

  List<Vertex> get keys => adjacencyList.keys.toList();

  List<VehicleEdge> get values => adjacencyList.values.toList().reduce((List<VehicleEdge> value, List<VehicleEdge> element) => value + element);
}
