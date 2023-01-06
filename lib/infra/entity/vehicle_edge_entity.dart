import 'package:path_finder/infra/entity/transit_edge_entity.dart';

class VehicleEdgeEntity extends TransitEdgeEntity {
  final String trackId;
  final String busName;
  final int timeInMin;
  final int timeToNextStop;
  
  const VehicleEdgeEntity({
    required int from,
    required int to,
    required this.trackId,
    required this.busName,
    required this.timeInMin,
    required this.timeToNextStop,
  }) : super(
    from: from,
    to: to,
  );
  
  factory VehicleEdgeEntity.fromJson(Map<String, dynamic> json) {
    return VehicleEdgeEntity(
      from: json['from'] as int,
      to: json['to'] as int,
      trackId: json['track_id'] as String,
      timeInMin: json['time_in_min'] as int,
      busName: json['bus_name'] as String,
      timeToNextStop: json['time_to_next_stop_in_min'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'track_id': trackId,
      'bus_name': busName,
      'time_in_min': timeInMin,
      'time_to_next_stop_in_min': timeToNextStop,
      'type': 'vehicle',
    };
  }

  @override
  List<Object?> get props => <Object?>[from, to, trackId, timeInMin, busName, timeToNextStop];
}