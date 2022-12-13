import 'package:equatable/equatable.dart';

class EdgeEntity extends Equatable {
  final int fromId;
  final int toId;
  final String trackShape;
  
  const EdgeEntity({
    required this.fromId,
    required this.toId,
    required this.trackShape,
  });
  
  factory EdgeEntity.fromJson(Map<String, dynamic> json) {
    return EdgeEntity(
      fromId: json['from_bus_stop'] as int,
      toId: json['to_bus_stop'] as int,
      trackShape: json['track_shape'] as String,
    );
  }
  
  @override
  List<Object?> get props => <Object?>[fromId, toId];
}