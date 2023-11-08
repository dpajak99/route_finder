import 'package:path_finder/infra/entity/transit_edge_entity.dart';

class VehicleEdgeEntity extends TransitEdgeEntity {
  final String trackId;
  final String busName;
  final int departureTimeInMin;
  final int timeToNextStopInMin;
  
  const VehicleEdgeEntity({
    required String from,
    required String to,
    required int distanceInMeters,
    required List<String> polylines,
    required this.trackId,
    required this.busName,
    required this.departureTimeInMin,
    required this.timeToNextStopInMin,
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
      departureTimeInMin: json['departure_time_in_min'] as int,
      timeToNextStopInMin: json['time_to_next_stop_in_min'] as int,
      trackId: json['track_id'] as String,
      busName: json['name'] as String,
      distanceInMeters: distanceInMeters,
      polylines: <String>[polyline],
    );
  }

  factory VehicleEdgeEntity.fromAssetsJson(Map<String, dynamic> json) {
    return VehicleEdgeEntity(
      from: json['from'] as String,
      to: json['to'] as String,
      trackId: json['track_id'] as String,
      departureTimeInMin: json['departure_time_in_min'] as int,
      timeToNextStopInMin: json['time_to_next_stop_in_min'] as int,
      busName: json['name'] as String,
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
      'name': busName,
      'departure_time_in_min': departureTimeInMin,
      'time_to_next_stop_in_min': timeToNextStopInMin,
      'type': 'vehicle',
    };
  }

  @override
  List<Object?> get props => <Object?>[from, to, distanceInMeters, polylines, trackId, departureTimeInMin, busName, timeToNextStopInMin];
}