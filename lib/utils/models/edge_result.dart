import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/transit_search_request.dart';

class TransitEdgeResult extends Equatable {
  final TransitEdge transitEdge;
  final TransitSearchRequest transitSearchRequest;
  final FullEdgeTime fullEdgeTime;

  final double edgeTimeStart;
  final double edgeTimeEnd;

  final double? edgeCost;

  const TransitEdgeResult({
    required this.transitEdge,
    required this.transitSearchRequest,
    required this.fullEdgeTime,
    required this.edgeTimeStart,
    required this.edgeTimeEnd,
    this.edgeCost,
  });
  
  
  @override
  List<Object?> get props => <Object?>[
    transitEdge,
    edgeCost,
    edgeTimeStart,
    edgeTimeEnd,
  ];
  

  @override
  String toString() {
    return '${transitEdge.runtimeType}\t\t ($edgeCost) - start: ${parseMinToString(edgeTimeStart)}  | wait: ${fullEdgeTime.waitingTime}, | transit: ${fullEdgeTime.transitTime}, total ${parseMinToString(fullEdgeTime.total)}| end ${parseMinToString(edgeTimeEnd)}';
  }
  
  String parseMinToString(num min) {
    int hour = min ~/ 60;
    int minute = min.toInt() % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
