import 'package:equatable/equatable.dart';

class PolylineDto extends Equatable {
  final String encodedPolyline;

  const PolylineDto({
    required this.encodedPolyline,
  });

  factory PolylineDto.fromJson(Map<String, dynamic> json)  {
    return PolylineDto(
      encodedPolyline: json['encodedPolyline'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'encodedPolyline': encodedPolyline,
    };
  }
  
  @override
  List<Object?> get props => <Object?>[encodedPolyline];
}