import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopMarker extends Marker {
  final StopVertex stopVertex;

  StopMarker({required this.stopVertex, required WidgetBuilder builder})
      : super(
          point: LatLng(stopVertex.lat, stopVertex.long),
          builder: builder,
        );
}
