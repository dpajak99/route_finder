import 'package:equatable/equatable.dart';
import 'package:flutter_map/plugin_api.dart';

class MapMarkersState extends Equatable {
  final List<Marker> markers;

  const MapMarkersState({
    required this.markers,
  });

  @override
  List<Object> get props => <Object>[markers];
}
