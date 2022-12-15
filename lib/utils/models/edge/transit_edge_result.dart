import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';

class TransitEdgeResult extends Equatable {
  final int departureTime;
  final int arrivalTime;
  final Duration waitingDuration;
  final Duration transitDuration;
  final TransitEdge transitEdge;

  TransitEdgeResult({
    required this.departureTime,
    required this.arrivalTime,
    required this.waitingDuration,
    required this.transitEdge,
  }) : transitDuration = Duration(seconds: arrivalTime - departureTime);

  @override
  List<Object?> get props => <Object>[departureTime, arrivalTime, waitingDuration, transitDuration, transitEdge];
}
