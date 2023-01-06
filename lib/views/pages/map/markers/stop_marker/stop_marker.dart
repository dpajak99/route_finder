import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/views/pages/map/markers/stop_marker/stop_marker_widget.dart';

class StopMarker extends Marker {
  final StopVertex stopVertex;

  StopMarker({
    required this.stopVertex,
    WidgetBuilder? builder,
    double width = 30.0,
    double height = 30.0,
  }) : super(
          point: stopVertex.latLng,
          width: width,
          height: height,
          anchorPos: AnchorPos.align(AnchorAlign.center),
          builder: builder ?? (_) => StopMarkerWidget(stopVertex: stopVertex),
        );
}
