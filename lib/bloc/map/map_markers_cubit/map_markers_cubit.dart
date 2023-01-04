import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_finder/bloc/map/map_markers_cubit/map_markers_state.dart';

class MapMarkersCubit extends Cubit<MapMarkersState> {
  MapMarkersCubit() : super(const MapMarkersState(markers: <Marker>[]));
  
  void setMarkers(List<Marker> markers) {
    emit(MapMarkersState(markers: markers));
  }
}