import 'package:path_finder/utils/models/vertex/geo_vertex.dart';

class StopVertex extends GeoVertex {
  final String name;

  const StopVertex({
    required this.name,
    required double lat,
    required double long,
    required String id,
  }) : super(lat: lat, long: long, id: id);

  @override
  List<Object?> get props => <Object>[id, lat, long, name];
}
