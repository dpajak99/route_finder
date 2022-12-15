import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/markers/stop_marker.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/views/pages/stop_marker_widget.dart';
import 'package:path_finder/views/pages/transit_stop_marker_widget.dart';

class TransitStopMarker extends StopMarker {
  final TransitEdge transitEdge;

  TransitStopMarker({required this.transitEdge, required StopVertex stopVertex})
      : super(
          stopVertex: stopVertex,
          width: 300,
          height: 150,
          builder: (_) => TransitStopMarkerWidget(stopVertex: stopVertex, transitEdge: transitEdge),
        );
}
