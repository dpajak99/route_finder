import 'package:path_finder/infra/entity/transit_edge_entity.dart';

class WalkEdgeEntity extends TransitEdgeEntity {
  final double distanceInMeters;
  
  const WalkEdgeEntity({
    required int from,
    required int to,
    required this.distanceInMeters,
  }) : super(
    from: from,
    to: to,
  );
  
  factory WalkEdgeEntity.fromJson(Map<String, dynamic> json) {
    return WalkEdgeEntity(
      from: json['from'] as int,
      to: json['to'] as int,
      distanceInMeters: json['distance'] as double,
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'distance': distanceInMeters,
      'type': 'walk',
    };
  }

  @override
  List<Object?> get props => <Object?>[from, to, distanceInMeters];
}