import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class TransitStopMarkerWidget extends StatelessWidget {
  final TransitEdgeResult transitEdgeResult;
  final StopVertex stopVertex;
  final bool isLast;

  const TransitStopMarkerWidget({
    required this.transitEdgeResult,
    required this.stopVertex,
    required this.isLast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Text(stopVertex.name.toString()),
          ),
          Container(
            color: Colors.white,
            child: Text(minutesToString(
              isLast ? transitEdgeResult.currentTime + transitEdgeResult.edgeTimeEnd : transitEdgeResult.currentTime + transitEdgeResult.edgeTimeStart + transitEdgeResult.edgeTimeWait
            )),
          ),
        ],
      ),
    );
  }

  String minutesToString(int minutes) {
    int hours = minutes ~/ 60;
    int minutesLeft = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutesLeft.toString().padLeft(2, '0')}';
  }
}
