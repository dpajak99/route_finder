import 'package:equatable/equatable.dart';

abstract class TransitEdgeEntity extends Equatable {
  final String from;
  final String to;
  final int distanceInMeters;
  final List<String> polylines;
  
  const TransitEdgeEntity({
    required this.from,
    required this.to,
    required this.distanceInMeters,
    required this.polylines,
  });

  @override
  List<Object?> get props => <Object?>[from, to];
}
