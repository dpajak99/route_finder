import 'package:path_finder/utils/models/vertex/vertex.dart';

class GeoVertex extends Vertex {
  final double lat;
  final double long;

  const GeoVertex({
    required this.lat,
    required this.long,
    required String id,
  }) : super(id: id);

  @override
  List<Object?> get props => <Object>[id, lat, long];
}
