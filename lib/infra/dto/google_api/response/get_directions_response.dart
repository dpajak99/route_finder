import 'package:equatable/equatable.dart';
import 'package:path_finder/infra/dto/google_api/response/route_dto.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';

class GetDirectionsResponse extends Equatable {
  final String from;
  final String to;
  final List<RouteDto> routes;
  
  const GetDirectionsResponse({
    required this.from,
    required this.to,
    required this.routes,
  });
  
  factory GetDirectionsResponse.fromApiJson(Map<String, dynamic> json, String from, String to) {
    return GetDirectionsResponse(
      from: from,
      to: to,
      routes: (json['routes'] as List<dynamic>).map((dynamic e) => RouteDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  factory GetDirectionsResponse.fromAssetsJson(Map<String, dynamic> json) {
    return GetDirectionsResponse(
      from: json['from'] as String,
      to: json['to'] as String,
      routes: (json['routes'] as List<dynamic>).map((dynamic e) => RouteDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
  
  Map<String, dynamic> toJson(WalkEdge walkEdge) {
    return <String, dynamic>{
      'routes': routes.map((RouteDto e) => e.toJson()).toList(),
      'from': walkEdge.sourceVertex.id,
      'to': walkEdge.targetVertex.id,
    };
  }
  
  @override
  List<Object?> get props => <Object?>[from, to, routes];
}