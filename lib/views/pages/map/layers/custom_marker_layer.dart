import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
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
 
    return BlocBuilder<MapMarkersCubit, MapMarkersState>(
      bloc: mapMarkersCubit,
      builder: (BuildContext context, MapMarkersState mapMarkersState) {
        return MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            disableClusteringAtZoom: 13,
            size: const Size(40, 40),
            fitBoundsOptions: const FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: !mapMarkersState.editMode && mapMarkersState.visible ? mapMarkersState.markers : <Marker>[],
            polygonOptions: const PolygonOptions(borderColor: Colors.transparent, color: Colors.transparent, borderStrokeWidth: 1),
            builder: (BuildContext context, List<Marker> markers) {
              return FloatingActionButton(
                onPressed: null,
                child: Text(markers.length.toString()),
              );
            },
          ),
        );
      },
    );
  }
}
