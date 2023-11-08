import 'package:equatable/equatable.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:path_finder/views/pages/map/markers/stop_marker/stop_marker.dart';

class MapMarkersState extends Equatable {
  final List<StopMarker> markers;
  final bool visible;
  final bool editMode;

  const MapMarkersState({
    required this.markers,
    this.visible = true,
    this.editMode = false,
  });

  @override
  List<Object> get props => <Object>[markers, visible, editMode];
}
