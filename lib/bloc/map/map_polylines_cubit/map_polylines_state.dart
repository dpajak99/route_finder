import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPolylinesState extends Equatable {
  final List<Polyline> polylines;
  final bool visible;

  const MapPolylinesState({
    required this.polylines,
    this.visible = true,
  });

  @override
  List<Object> get props => <Object>[polylines, visible];
}
