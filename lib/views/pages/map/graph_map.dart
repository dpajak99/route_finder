import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/bloc/map/map_cubit.dart';
import 'package:path_finder/views/pages/map/layers/custom_draggable_marker_layer.dart';
import 'package:path_finder/views/pages/map/layers/custom_marker_layer.dart';
import 'package:path_finder/views/pages/map/layers/custom_polylines_layer.dart';

class GraphMap extends StatelessWidget {
  final MapCubit mapCubit;

  const GraphMap({
    required this.mapCubit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(50.012100, 20.985842),
        zoom: 9.2,
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        CustomPolylineLayer(mapPolylinesCubit: mapCubit.mapPolylinesCubit),
        CustomMarkerLayer(mapMarkersCubit: mapCubit.mapMarkersCubit),
        CustomDraggableMarkerLayer(mapMarkersCubit: mapCubit.mapMarkersCubit, mapPolylinesCubit: mapCubit.mapPolylinesCubit),
      ],
    );
  }
}
