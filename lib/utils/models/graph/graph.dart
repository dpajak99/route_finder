import 'package:path_finder/utils/models/vertex/vertex.dart';

abstract class Graph {
  bool containsVertex(Vertex v);
  
  void push();
  
  Vertex pop();
}