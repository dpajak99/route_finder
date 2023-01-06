import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_finder/bloc/map/map_polylines_cubit/map_polylines_state.dart';

class MapPolylinesCubit extends Cubit<MapPolylinesState> {
  MapPolylinesCubit() : super(const MapPolylinesState(polylines: <Polyline>[]));
  
  void setPolylines(List<Polyline> polylines) {
    emit(MapPolylinesState(polylines: polylines, visible: state.visible));
  }

  void setVisible({required bool visible}) {
    emit(MapPolylinesState(polylines: state.polylines, visible: visible));
  }
}