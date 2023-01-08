import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/utils/time_utils.dart';

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
    return Container(
      width: 300,
      height: 150,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.fromBorderSide(BorderSide(color: Colors.black)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(
                    edgeDetails.transitEdge is VehicleEdge ? Icons.directions_bus_filled : Icons.directions_walk,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  if (edgeDetails.transitEdge is VehicleEdge)
                    Text(
                      (edgeDetails.transitEdge as VehicleEdge).name,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              if (edgeDetails.transitEdge is VehicleEdge) ...<Widget>[
                const SizedBox(width: 10),
                SizedBox(
                  width: 25,
                  height: 25,
                  child: SvgPicture.string(
                    Jdenticon.toSvg((edgeDetails.transitEdge as VehicleEdge).trackId),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  stopVertex.name.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    const SizedBox(width: double.infinity, child: Text('Edge cost:', overflow: TextOverflow.ellipsis)),
                    if (edgeDetails.transitEdge is VehicleEdge)
                      const SizedBox(width: double.infinity, child: Text('Departure time:', overflow: TextOverflow.ellipsis)),
                    if (edgeDetails.transitEdge is WalkEdge) const SizedBox(width: double.infinity, child: Text('Walk time:', overflow: TextOverflow.ellipsis)),
                    if (edgeDetails.transitEdge is VehicleEdge)
                      const SizedBox(width: double.infinity, child: Text('Waiting time:', overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: double.infinity, child: Text('Total trip time:', overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SizedBox(width: double.infinity, child: Text(edgeDetails.cost.toString(), overflow: TextOverflow.ellipsis)),
                    if (edgeDetails.transitEdge is VehicleEdge)
                      SizedBox(width: double.infinity, child: Text(TimeUtils.minutesToString(edgeDetails.departureTime), overflow: TextOverflow.ellipsis)),
                    if (edgeDetails.transitEdge is WalkEdge)
                      SizedBox(width: double.infinity, child: Text(TimeUtils.minutesToString(edgeDetails.fullTime.total), overflow: TextOverflow.ellipsis)),
                    if (edgeDetails.transitEdge is VehicleEdge)
                      SizedBox(
                          width: double.infinity, child: Text(TimeUtils.minutesToString(edgeDetails.fullTime.waitingTime), overflow: TextOverflow.ellipsis)),
                    SizedBox(width: double.infinity, child: Text(TimeUtils.minutesToString(time), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double get time {
    if (isLast) {
      return edgeDetails.edgeTimeEnd;
    } else {
      return edgeDetails.edgeTimeStart;
    }
  }
}
