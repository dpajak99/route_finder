import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:path_finder/bloc/map/map_markers_cubit/map_markers_cubit.dart';
import 'package:path_finder/bloc/map/map_markers_cubit/map_markers_state.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/views/pages/map/markers/stop_marker/stop_marker.dart';

class CustomMarkerLayer extends StatelessWidget {
  final MapMarkersCubit mapMarkersCubit;

  const CustomMarkerLayer({
    required this.mapMarkersCubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StopSelectCubit stopSelectCubit = getIt<StopSelectCubit>();

    return BlocBuilder<MapMarkersCubit, MapMarkersState>(
      bloc: mapMarkersCubit,
      builder: (BuildContext context, MapMarkersState mapMarkersState) {
        return PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
            markerTapBehavior: MarkerTapBehavior.custom((Marker marker, PopupState popupState, PopupController popupController) {
              StopMarker stopMarker = marker as StopMarker;
              stopSelectCubit.updateSelectedVertex(stopMarker.stopVertex);
            }),
            popupBuilder: (BuildContext context, Marker marker) => Container(
              color: Colors.white,
              child: Text((marker as StopMarker).stopVertex.name.toString()),
            ),
            markers: mapMarkersState.markers,
          ),
        );
      },
    );
  }
}
