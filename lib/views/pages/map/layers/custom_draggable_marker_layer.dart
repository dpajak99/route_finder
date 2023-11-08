import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/bloc/map/map_markers_cubit/map_markers_cubit.dart';
import 'package:path_finder/bloc/map/map_markers_cubit/map_markers_state.dart';
import 'package:path_finder/bloc/map/map_polylines_cubit/map_polylines_cubit.dart';
import 'package:path_finder/views/pages/map/markers/stop_marker/stop_marker.dart';

class CustomDraggableMarkerLayer extends StatelessWidget {
  final MapMarkersCubit mapMarkersCubit;
  final MapPolylinesCubit mapPolylinesCubit;

  const CustomDraggableMarkerLayer({
    required this.mapMarkersCubit,
    required this.mapPolylinesCubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapMarkersCubit, MapMarkersState>(
      bloc: mapMarkersCubit,
      builder: (BuildContext context, MapMarkersState mapMarkersState) {
        List<StopMarker> markers = mapMarkersState.markers;
        List<DragMarker> dragMarkers = markers
            .map((StopMarker marker) => DragMarker(
                  point: marker.point,
                  builder: (BuildContext context) {
                    return const Icon(Icons.circle, color: Colors.red, size: 20);
                  },
                  onDragEnd: (DragEndDetails dragEndDetails, LatLng point) async {
                    bool acceptChange = await showDialog<bool>(context: context, builder: (_) => const AcceptStopChangeDialog()) ?? false;
                    if (acceptChange) {
                      await mapMarkersCubit.updateStopCoords(marker, point);
                    }
                  },
                ))
            .toList();
        return DragMarkers(
          markers: mapMarkersState.editMode && mapMarkersState.visible ? dragMarkers : <DragMarker>[],
        );
      },
    );
  }
}

class AcceptStopChangeDialog extends StatelessWidget {
  const AcceptStopChangeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Accept stop change?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('No'),
        ),
      ],
    );
  }
}
