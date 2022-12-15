import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/views/pages/stop_marker_widget.dart';

class StopMarker extends Marker {
  final StopVertex stopVertex;

  StopMarker({
    required this.stopVertex,
    WidgetBuilder? builder,
    double width = 30.0,
    double height = 30.0,
  }) : super(
          point: LatLng(stopVertex.lat, stopVertex.long),
          width: width,
          height: height,
          anchorPos: AnchorPos.align(AnchorAlign.center),
          builder: builder ?? (_) => StopMarkerWidget(stopVertex: stopVertex),
        );
}
