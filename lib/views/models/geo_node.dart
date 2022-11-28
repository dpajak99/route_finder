import 'package:equatable/equatable.dart';

class GeoNode extends Equatable {
  final String id;
  final double lat;
  final double long;

  const GeoNode(this.id, this.lat, this.long);

  @override
  List<Object?> get props => [id, lat, long];
}