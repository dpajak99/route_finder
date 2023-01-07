import 'package:path_finder/infra/entity/transit_edge_entity.dart';

class WalkEdgeEntity extends TransitEdgeEntity {
  const WalkEdgeEntity({
    required String from,
    required String to,
    required int distanceInMeters,
    required List<String> polylines,
  }) : super(
    from: from,
    to: to,
    distanceInMeters: distanceInMeters,
    polylines: polylines,
  );
  
  factory WalkEdgeEntity.fromJson(Map<String, dynamic> json) {
    return WalkEdgeEntity(
      from: json['from'] as String,
      to: json['to'] as String,
      distanceInMeters: json['distance_in_meters'] as int,
      polylines: (json['polylines'] as List<dynamic>).map((dynamic e) => e as String).toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'distance_in_meters': distanceInMeters,
      'polylines': polylines,
      'type': 'walk',
    };
  }

  @override
  List<Object?> get props => <Object?>[from, to, distanceInMeters, polylines];
}