import 'package:latlong2/latlong.dart';
import 'package:path_finder/utils/models/vertex/vertex.dart';

class GeoVertex extends Vertex {
  final LatLng latLng;

  const GeoVertex({
    required this.latLng,
    required String id,
  }) : super(id: id);

  @override
  List<Object?> get props => <Object>[id, latLng];
}
