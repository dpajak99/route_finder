import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class TransitStopMarkerWidget extends StatelessWidget {
  final EdgeDetails edgeDetails;
  final StopVertex stopVertex;
  final bool isLast;

  const TransitStopMarkerWidget({
    required this.edgeDetails,
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
            child: Text(edgeDetails.cost.toString()),
          ),
          Container(
            color: Colors.white,
            child: Text('${minutesToString(time)} (${edgeDetails.fullTime.waitingTime})'),
          ),
        ],
      ),
    );
  }

  double get time {
    if(isLast) {
      return edgeDetails.edgeTimeEnd;
    } else {
      return edgeDetails.edgeTimeStart;
    }
  }

  String minutesToString(num minutes) {
    int hours = minutes ~/ 60;
    int minutesLeft = minutes.toInt() % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutesLeft.toString().padLeft(2, '0')}';
  }
}
