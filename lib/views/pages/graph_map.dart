import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_cubit.dart';
import 'package:path_finder/bloc/graph_map_cubit/graph_map_state.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/markers/stop_marker.dart';
import 'package:path_finder/utils/models/vertex/geo_vertex.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class GraphMap extends StatelessWidget {
  final GraphMapCubit graphMapCubit;

  const GraphMap({
    required this.graphMapCubit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphMapCubit, GraphMapState>(
      bloc: graphMapCubit,
      builder: (BuildContext context, GraphMapState state) {
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
            if (state is GraphMapLoadedState) ...<Widget>[
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  markerTapBehavior: MarkerTapBehavior.custom((Marker marker, PopupState popupState, PopupController popupController) {
                    StopMarker stopMarker = marker as StopMarker;
                    graphMapCubit.addVertex(stopMarker.stopVertex);
                    // List<VehicleEdge> edgesFromVertex = state.directedGraph[stopMarker.stopVertex]!;
                    // for (VehicleEdge edge in edgesFromVertex) {
                    //   print('edge: $edge');
                    // }
                  }),
                  popupBuilder: (BuildContext context, Marker marker) => Container(
                    color: Colors.white,
                    child: Text((marker as StopMarker).stopVertex.name.toString()),
                  ),
                  markers: state.vertices.map((GeoVertex geoVertex) {
                    return StopMarker(
                        stopVertex: geoVertex as StopVertex,
                        builder: (BuildContext context) {
                          return const Icon(Icons.location_on);
                        });
                  }).toList(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
