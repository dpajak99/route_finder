import 'package:latlong2/latlong.dart';
import 'package:path_finder/utils/models/vertex/geo_vertex.dart';

class StopVertex extends GeoVertex {
  final String name;

  const StopVertex({
    required this.name,
    required String id,
    required LatLng latLng,
  }) : super(id: id, latLng: latLng);

  @override
  List<Object?> get props => <Object>[id, latLng, name];
}
