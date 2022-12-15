import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class TransitStopMarkerWidget extends StatelessWidget {
  final StopVertex stopVertex;
  final TransitEdge transitEdge;

  const TransitStopMarkerWidget({
    required this.stopVertex,
    required this.transitEdge,
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
            child: Text(transitEdge.sourceVertex.name.toString()),
          ),
          if (transitEdge is VehicleEdge)
            Container(
              color: Colors.white,
              child: Text((transitEdge as VehicleEdge).getTimeAsString()),
            ),
        ],
      ),
    );
  }
}
