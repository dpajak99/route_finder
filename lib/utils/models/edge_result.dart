import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';

class TransitEdgeResult extends Equatable {
  final TransitEdge transitEdge;
  final int currentTime;
  
  final double totalCost;
  final int totalTime;

  final double edgeCost;
  final int edgeTime;
  
  final int edgeTimeStart;
  final int edgeTimeWait;
  final int edgeTimeTransit;
  final int edgeTimeEnd;

  const TransitEdgeResult({
    required this.transitEdge,
    required this.currentTime,
    
    required this.totalCost,
    required this.totalTime,
    
    required this.edgeCost,
    required this.edgeTime,
    
    required this.edgeTimeStart,
    required this.edgeTimeWait,
    required this.edgeTimeTransit,
    required this.edgeTimeEnd,
  });
  
  
  @override
  List<Object?> get props => <Object>[
    transitEdge,
    currentTime,
    totalCost,
    totalTime,
    edgeCost,
    edgeTime,
    edgeTimeStart,
    edgeTimeWait,
    edgeTimeTransit,
    edgeTimeEnd,
  ];
  
  
  @override
  String toString() {
    return '${transitEdge.runtimeType}\t\t ($edgeCost) - start: ${parseMinToString(edgeTimeStart)}  | wait: ${edgeTimeWait}, | transit: ${edgeTimeTransit}, total ${parseMinToString(edgeTime)}| end ${parseMinToString(edgeTimeEnd)}';
  }
  
  String parseMinToString(int min) {
    int hour = min ~/ 60;
    int minute = min % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
