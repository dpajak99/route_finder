import 'package:equatable/equatable.dart';
import 'package:path_finder/infra/dto/google_api/response/polyline_dto.dart';

class RouteDto extends Equatable {
  final int distanceMeters;
  final String duration;
  final PolylineDto polylineDto;
  
  const RouteDto({
    required this.distanceMeters,
    required this.duration,
    required this.polylineDto,
  });
  
  factory RouteDto.fromJson(Map<String, dynamic> json) {
    return RouteDto(
      distanceMeters: json['distanceMeters'] as int,
      duration: json['duration'] as String,
      polylineDto: PolylineDto.fromJson(json['polyline'] as Map<String, dynamic>),
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'distanceMeters': distanceMeters,
      'duration': duration,
      'polyline': polylineDto.toJson(),
    };
  }
  
  @override
  List<Object?> get props => <Object?>[distanceMeters, duration, polylineDto];
}