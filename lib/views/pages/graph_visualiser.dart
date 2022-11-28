import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_finder/views/models/a_star_node_wrapper.dart';
import 'package:path_finder/views/models/endpoint_pair.dart';
import 'package:path_finder/views/models/geo_node.dart';
import 'package:path_finder/views/models/value_graph.dart';

class GraphVisualiser extends StatefulWidget {
  final ValueGraph<GeoNode, double> graph;
  final List<AStarNodeWrapper>? solution;

  const GraphVisualiser({
    required this.graph,
    this.solution,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GraphVisualiserState();
}

class _GraphVisualiserState extends State<GraphVisualiser> {
  Offset scrollOffset = Offset.zero;
  Offset zoomOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: const SizedBox(),
      onDragUpdate: (DragUpdateDetails details) {
        setState(() {
          scrollOffset += details.delta;
        });
      },
      child: Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            setState(() {
              zoomOffset += pointerSignal.scrollDelta;
            });
          }
        },
        child: Container(
          width: 500,
          height: 500,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: ClipRRect(
            child: CustomPaint(
              painter: GraphVisualiserPainter(
                graph: widget.graph,
                solution: widget.solution,
                scrollOffset: scrollOffset,
                zoomOffset: zoomOffset,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GraphVisualiserPainter extends CustomPainter {
  final ValueGraph<GeoNode, double> graph;
  final List<AStarNodeWrapper>? solution;
  final Offset scrollOffset;
  final Offset zoomOffset;

  GraphVisualiserPainter({
    required this.graph,
    required this.scrollOffset,
    required this.zoomOffset,
    this.solution,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (EndpointPair<GeoNode, double> edge in graph.edges) {
      drawEdge(canvas, edge);
      drawEdgeWeight(canvas, size, edge);
    }

    for (GeoNode node in graph.nodes) {
      drawNode(canvas, node);
      drawNodeName(canvas, size, node);
    }

    for (AStarNodeWrapper edge in solution ?? []) {
      drawNode(canvas, edge.geoNode, Colors.green);
      if (edge.parent != null) {
        drawEdge(canvas, EndpointPair<GeoNode, double>(endNode: edge.geoNode, startNode: edge.parent!.geoNode, value: 0), Colors.green);
      }
    }
  }

  void drawNode(Canvas canvas, GeoNode geoNode, [Color color = Colors.red]) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = color;

    Offset nodeOffset = calculateMapNodePosition(geoNode);
    canvas.drawCircle(nodeOffset, 5, paint);
  }

  void drawNodeName(Canvas canvas, Size size, GeoNode geoNode) {
    Offset nodeOffset = calculateMapNodePosition(geoNode);

    const textStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    TextSpan textSpan = TextSpan(
      text: '${geoNode.id} (${geoNode.lat}, ${geoNode.long})',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    Offset textTitleOffset = Offset(nodeOffset.dx, nodeOffset.dy - 20);
    textPainter.paint(canvas, textTitleOffset);
  }

  void drawEdge(Canvas canvas, EndpointPair<GeoNode, double> edge, [Color color = Colors.indigo]) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = color;

    Offset p1 = calculateMapNodePosition(edge.startNode);
    Offset p2 = calculateMapNodePosition(edge.endNode);

    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;

    double angle = atan2(dy, dx);
    double arrowSize = 10;
    double arrowAngle = 25 * pi / 180;

    Path path = Path();
    path.moveTo(p2.dx - arrowSize * cos(angle - arrowAngle), p2.dy - arrowSize * sin(angle - arrowAngle));
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p2.dx - arrowSize * cos(angle + arrowAngle), p2.dy - arrowSize * sin(angle + arrowAngle));
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawLine(
      calculateMapNodePosition(edge.startNode),
      calculateMapNodePosition(edge.endNode),
      paint,
    );
  }

  void drawEdgeWeight(Canvas canvas, Size size, EndpointPair<GeoNode, double> edge, [Color color = Colors.indigo]) {
    Offset p1 = calculateMapNodePosition(edge.startNode);
    Offset p2 = calculateMapNodePosition(edge.endNode);

    Offset s = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);

    const textStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    TextSpan textSpan = TextSpan(
      text: '${edge.value}',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, s);
  }

  Offset calculateMapNodePosition(GeoNode node) {
    double percentX = 100 * (node.lat / 10);
    double percentY = 100 * (node.long / 10);

    double x = (percentX * (500 - zoomOffset.dy) / 100) + scrollOffset.dx;
    double y = (percentY * (500 - zoomOffset.dy) / 100) + scrollOffset.dy;

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
