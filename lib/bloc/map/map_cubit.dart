import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/bloc/map/map_markers_cubit/map_markers_cubit.dart';
import 'package:path_finder/bloc/map/map_polylines_cubit/map_polylines_cubit.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_result.dart';
import 'package:path_finder/utils/google_coords_utils.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/views/pages/map/markers/stop_marker/stop_marker.dart';
import 'package:path_finder/views/pages/map/markers/transit_stop_marker/transit_stop_marker.dart';

class MapCubit extends Cubit<void> {
  final MapMarkersCubit mapMarkersCubit = MapMarkersCubit();
  final MapPolylinesCubit mapPolylinesCubit = MapPolylinesCubit();
  
  MapCubit() : super(null);
  
  List<StopVertex> previousAllStopVertices = <StopVertex>[];
  
  void reset() {
    mapPolylinesCubit.setPolylines(<Polyline>[]);
    setVisibleStops(previousAllStopVertices);
  }
  
  void setVisibleStops(List<StopVertex> stopVertexList) {
    previousAllStopVertices = stopVertexList;
    List<StopMarker> markers = stopVertexList.map((StopVertex e) => StopMarker(stopVertex: e)).toList();
    mapMarkersCubit.setMarkers(markers);
  }  
  void setVisibleSearchResult(PathfinderResult pathfinderResult) {
    List<EdgeDetails> path = pathfinderResult.path;
    List<StopMarker> markers = List<StopMarker>.empty(growable: true);
    for (int i = 0; i < path.length; i++) {
      EdgeDetails edgeDetails = path[i];
      bool isLast = i == path.length - 1;
      markers.add(TransitStopMarker(
        stopVertex: edgeDetails.transitEdge.sourceVertex,
        edgeDetails: edgeDetails,
        isLast: false,
      ));
      if (isLast) {
        markers.add(TransitStopMarker(
          stopVertex: edgeDetails.transitEdge.targetVertex,
          edgeDetails: edgeDetails,
          isLast: true,
        ));
      }
    }
    
    List<Polyline> polylines =  path.map((EdgeDetails e) {
      List<LatLng> latLngList = List<LatLng>.empty(growable: true);
      for( String polyline in e.transitEdge.polylines) {
        latLngList.addAll(GoogleCoordsUtils.decodePolyline(polyline));
      }
      return Polyline(
        points: latLngList,
        strokeWidth: 5.0,
        color: e.transitEdge is WalkEdge ? Colors.red : Colors.blue,
        isDotted: e.transitEdge is WalkEdge,
      );
    }).toList();
    
    mapMarkersCubit.setMarkers(markers);
    mapPolylinesCubit.setPolylines(polylines);
  }
}