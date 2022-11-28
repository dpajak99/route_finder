import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_finder/views/models/a_star.dart';
import 'package:path_finder/views/models/a_star_node_wrapper.dart';
import 'package:path_finder/views/models/geo_node.dart';
import 'package:path_finder/views/models/geo_node_heuristic.dart';
import 'package:path_finder/views/models/value_graph.dart';
import 'package:path_finder/views/pages/graph_visualiser.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  ValueGraph<GeoNode, double> graph = createSampleGraph();

  late Map<String, GeoNode> nodeByName = graph.nodesMap;

  List<AStarNodeWrapper>? solution;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      child: Material(
        child: SafeArea(
          child: Center(
              child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50, child: TextField(controller: startController, decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 1))))),
                  const SizedBox(width: 25),
                  SizedBox(width: 50, child: TextField(controller: endController, decoration: const InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 1))))),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(onPressed: () => _findSolution(startController.text, endController.text), child: const Text('Find Solution')),
              Text(solution?.toString() ?? 'undefined'),
              GraphVisualiser(
                graph: graph,
                solution: solution,
              ),
            ],
          )),
        ),
      ),
    );
  }

  void _findSolution(String name1, String name2) {
    GeoNode sourceNode = nodeByName[name1]!;
    GeoNode targetNode = nodeByName[name2]!;

    solution = AStar().solve(
      graph: graph,
      source: sourceNode,
      target: targetNode,
    );

    print('solution: $solution');
    setState(() {});
  }

  static ValueGraph<GeoNode, double> createSampleGraph() {
    ValueGraph<GeoNode, double> graph = ValueGraph<GeoNode, double>();

    GeoNode a = const GeoNode("A", 1, 1);
    GeoNode b = const GeoNode("B", 2, 6);
    GeoNode c = const GeoNode("C", 5, 4);
    GeoNode d = const GeoNode("D", 7, 1);
    GeoNode e = const GeoNode("E", 7, 7);
    GeoNode f = const GeoNode("F", 3, 3);
    GeoNode g = const GeoNode("G", 4, 7);

    graph.putEdgeValue(a, b, 2.0);
    graph.putEdgeValue(a, f, 6.2);
    graph.putEdgeValue(b, g, 2.0);
    graph.putEdgeValue(g, f, 2.0);
    graph.putEdgeValue(f, e, 2.0);
    graph.putEdgeValue(e, c, 2.0);
    graph.putEdgeValue(c, d, 2.0);
    graph.putEdgeValue(d, a, 2.0);

    return graph;
  }
}
