import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/bloc/map/map_markers_cubit/map_markers_state.dart';
import 'package:path_finder/infra/repository/postgres/postgres_stop_repository.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/views/pages/map/markers/stop_marker/stop_marker.dart';

class MapMarkersCubit extends Cubit<MapMarkersState> {  
  MapMarkersCubit() : super(const MapMarkersState(markers: <StopMarker>[]));
  
  void setMarkers(List<StopMarker> markers, {bool? visible}) {
    emit(MapMarkersState(markers: markers, visible: state.visible, editMode: state.editMode));
  }
  
  void setVisible({required bool visible}) {
    emit(MapMarkersState(markers: state.markers, visible: visible, editMode: state.editMode));
  }
  
  void setEditMode({required bool editMode}) {
    emit(MapMarkersState(markers: state.markers, visible: state.visible, editMode: editMode));
  }
  
  Future<void> updateStopCoords(StopMarker stopMarker, LatLng point) async {
    try {
      PostgresStopRepository postgresStopRepository = PostgresStopRepository();
      await postgresStopRepository.updateCoords(int.parse(stopMarker.stopVertex.id), point.latitude, point.longitude);
      print('Stop coords updated ${stopMarker.stopVertex.name} ${point.latitude} ${point.longitude}');
    } catch (e) {
      print('Postgres connection unavailable');
    }
  }
}