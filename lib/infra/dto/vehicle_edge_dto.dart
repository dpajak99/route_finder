import 'package:equatable/equatable.dart';

class VehicleEdgeDto extends Equatable {
  final int from;
  final int to;
  final String trackId;
  final String busName;
  final int timeInMin;
  final int timeFromNow;
  final int timeToNextStop;
  
  const VehicleEdgeDto({
    required this.from,
    required this.to,
    required this.trackId,
    required this.busName,
    required this.timeInMin,
    required this.timeFromNow,
    required this.timeToNextStop,
  });
  
  factory VehicleEdgeDto.fromJson(Map<String, dynamic> json) {
    return VehicleEdgeDto(
      from: json['from'] as int,
      to: json['to'] as int,
      trackId: json['track_id'] as String,
      timeInMin: json['time_in_min'] as int,
      busName: json['bus_name'] as String,
      timeFromNow: json['time_from_now'] as int,
      timeToNextStop: json['time_to_next_stop_in_min'] as int,
    );
  }

  @override
  List<Object?> get props => <Object?>[from, to, trackId, timeFromNow];
}