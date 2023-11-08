import 'package:equatable/equatable.dart';

class StopEntity extends Equatable {
  final int id;
  final String name;
  final double lat;
  final double lng;
  final String city;

  const StopEntity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.city,
  });
  
  factory StopEntity.fromJson(Map<String, dynamic> json) {
    return StopEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      lat: json['lat'] as double? ?? 0,
      lng: json['lng'] as double? ?? 0,
      city: json['city'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lat': lat,
      'lng': lng,
      'city': city,
    };
  }

  @override
  List<Object?> get props => <Object>[id, name, lat, lng, city];
}
