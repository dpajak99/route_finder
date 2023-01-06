import 'package:path_finder/infra/entity/transit_edge_entity.dart';

class WalkEdgeEntity extends TransitEdgeEntity {
  final double distance;
  
  const WalkEdgeEntity({
    required int from,
    required int to,
    required this.distance,
  }) : super(
    from: from,
    to: to,
  );
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'distance': distance,
    };
  }

  @override
  List<Object?> get props => <Object?>[from, to, distance];
}