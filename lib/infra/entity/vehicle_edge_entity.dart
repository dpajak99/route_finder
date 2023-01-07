import 'package:path_finder/infra/entity/transit_edge_entity.dart';

class VehicleEdgeEntity extends TransitEdgeEntity {
  final String trackId;
  final String busName;
  final int timeInMin;
  final int timeToNextStop;
  
  const VehicleEdgeEntity({
    required String from,
    required String to,
    required int distanceInMeters,
    required List<String> polylines,
    required this.trackId,
    required this.busName,
    required this.timeInMin,
    required this.timeToNextStop,
  }) : super(
    from: from,
    to: to,
    distanceInMeters: distanceInMeters,
    polylines: polylines,
  );
  
  factory VehicleEdgeEntity.fromPostgresJson(Map<String, dynamic> json, int distanceInMeters, String polyline) {
    return VehicleEdgeEntity(
      from: (json['from'] as int).toString(),
      to: (json['to'] as int).toString(),
      trackId: json['track_id'] as String,
      timeInMin: json['time_in_min'] as int,
      busName: json['bus_name'] as String,
      timeToNextStop: json['time_to_next_stop_in_min'] as int,
      distanceInMeters: distanceInMeters,
      polylines: <String>[polyline],
    );
  }

  factory VehicleEdgeEntity.fromAssetsJson(Map<String, dynamic> json) {
    return VehicleEdgeEntity(
      from: json['from'] as String,
      to: json['to'] as String,
      trackId: json['track_id'] as String,
      timeInMin: json['time_in_min'] as int,
      busName: json['bus_name'] as String,
      timeToNextStop: json['time_to_next_stop_in_min'] as int,
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
      'track_id': trackId,
      'bus_name': busName,
      'time_in_min': timeInMin,
      'time_to_next_stop_in_min': timeToNextStop,
      'type': 'vehicle',
    };
  }

  @override
  List<Object?> get props => <Object?>[from, to, distanceInMeters, polylines, trackId, timeInMin, busName, timeToNextStop];
}