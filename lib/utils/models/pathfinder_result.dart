// import 'package:path_finder/utils/models/edge/transit_edge.dart';
// import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
// import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
//
// class PathFinderResult {
//   final List<PathFinderResultAction> actions;
//
//   PathFinderResult({required this.actions});
//
//   factory PathFinderResult.fromEdges(List<TransitEdge> edges) {
//     final List<PathFinderResultAction> actions = <PathFinderResultAction>[];
//
//     for (int i = 0; i < edges.length; i++) {
//       TransitEdge currentEdge = edges[i];
//       TransitEdge? previousEdge = i > 0 ? edges[i - 1] : null;
//
//       if (i == 0) {
//         actions.add(StartAction.fromEdge(currentEdge));
//       } else if (i == edges.length - 1) {
//         actions.add(EndAction.fromEdge(currentEdge));
//       } else if (currentEdge is VehicleEdge) {
//         if (previousEdge is VehicleEdge && previousEdge.trackId != currentEdge.trackId) {
//           actions.add(TransferAction.fromEdge(currentEdge));
//         } else {
//           actions.add(RideAction.fromEdge(currentEdge));
//         }
//       } else {
//         actions.add(WalkAction.fromEdge(currentEdge));
//       }
//     }
//
//     return PathFinderResult(actions: actions);
//   }
//
//   void printRoute() {
//     for (PathFinderResultAction edge in actions) {
//       print(edge);
//     }
//   }
// }
//
// class PathFinderResultAction {
//   final StopVertex sourceVertex;
//   final StopVertex targetVertex;
//   final int departureTime;
//   final int arrivalTime;
//   final int actionDuration; 
//
//   PathFinderResultAction({
//     required this.sourceVertex,
//     required this.targetVertex,
//     required this.departureTime,
//     required this.arrivalTime,
//     required this.actionDuration,
//   });
//
//   PathFinderResultAction.fromEdge(TransitEdge transitEdge)
//       : this(
//           sourceVertex: transitEdge.sourceVertex,
//           targetVertex: transitEdge.targetVertex,
//           departureTime: transitEdge.departureTime,
//           arrivalTime: transitEdge.arrivalTime,
//           actionDuration: transitEdge.edgeTime.toInt(),
//         );
//
//   String minutesToTimeString(int minutes) {
//     int hours = minutes ~/ 60;
//     int minutesLeft = minutes % 60;
//     return '${hours.toString().padLeft(2, '0')}:${minutesLeft.toString().padLeft(2, '0')}';
//   }
// }
//
// class StartAction extends PathFinderResultAction {
//   StartAction.fromEdge(TransitEdge transitEdge)
//       : super(
//           actionDuration: transitEdge.edgeTime.toInt(),
//           sourceVertex: transitEdge.sourceVertex,
//           targetVertex: transitEdge.targetVertex,
//           departureTime: transitEdge.departureTime,
//           arrivalTime: transitEdge.arrivalTime,
//         );
//
//   @override
//   String toString() {
//     return 'START: ${minutesToTimeString(departureTime)} # $actionDuration # - ${sourceVertex.name} -> ${targetVertex.name} ';
//   }
// }
//
// class EndAction extends PathFinderResultAction {
//   EndAction.fromEdge(TransitEdge transitEdge)
//       : super(
//           actionDuration: transitEdge.edgeTime.toInt(),
//           sourceVertex: transitEdge.sourceVertex,
//           targetVertex: transitEdge.targetVertex,
//           departureTime: transitEdge.departureTime,
//           arrivalTime: transitEdge.arrivalTime,
//         );
//
//   @override
//   String toString() {
//     return 'END: ${minutesToTimeString(arrivalTime)} # $actionDuration # - ${sourceVertex.name} -> ${targetVertex.name} ';
//   }
// }
//
// class TransferAction extends PathFinderResultAction {
//   TransferAction.fromEdge(TransitEdge transitEdge)
//       : super(
//           actionDuration: transitEdge.edgeTime.toInt(),
//           sourceVertex: transitEdge.sourceVertex,
//           targetVertex: transitEdge.targetVertex,
//           departureTime: transitEdge.departureTime,
//           arrivalTime: transitEdge.arrivalTime,
//         );
//
//   @override
//   String toString() {
//     return 'TRANSFER: ${minutesToTimeString(departureTime)} # $actionDuration # - ${sourceVertex.name} -> ${targetVertex.name} ';
//   }
// }
//
// class WalkAction extends PathFinderResultAction {
//   WalkAction.fromEdge(TransitEdge transitEdge)
//       : super(
//           actionDuration: transitEdge.edgeTime.toInt(),
//           sourceVertex: transitEdge.sourceVertex,
//           targetVertex: transitEdge.targetVertex,
//           departureTime: transitEdge.departureTime,
//           arrivalTime: transitEdge.arrivalTime,
//         );
//
//   @override
//   String toString() {
//     return 'WALK: ${minutesToTimeString(departureTime)} # $actionDuration # - ${sourceVertex.name} -> ${targetVertex.name} ';
//   }
// }
//
// class RideAction extends PathFinderResultAction {
//   RideAction.fromEdge(TransitEdge transitEdge)
//       : super(
//           actionDuration: transitEdge.edgeTime.toInt(),
//           sourceVertex: transitEdge.sourceVertex,
//           targetVertex: transitEdge.targetVertex,
//           departureTime: transitEdge.departureTime,
//           arrivalTime: transitEdge.arrivalTime,
//         );
//
//   @override
//   String toString() {
//     return 'RIDE: ${minutesToTimeString(departureTime)} # $actionDuration # - ${sourceVertex.name} -> ${targetVertex.name} ';
//   }
// }
