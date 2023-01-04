import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPolylinesState extends Equatable {
  final List<Polyline> polylines;

  const MapPolylinesState({required this.polylines});

  @override
  List<Object> get props => <Object>[polylines];
}