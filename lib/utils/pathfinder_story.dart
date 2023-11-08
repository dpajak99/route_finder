import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class PathfinderStory {
  final List<EdgeDetails> path;
  final DateTime initialTime;

  PathfinderStory({
    required this.path,
    required this.initialTime,
  });

  List<PathfinderResultStoryAction> get story {
    List<PathfinderResultStoryAction> story = <PathfinderResultStoryAction>[];
    for (int i = 0; i < path.length; i++) {
      EdgeDetails edgeDetails = path[i];
      EdgeDetails? previousEdgeDetails = i > 0 ? path[i - 1] : null;
      EdgeDetails? nextEdgeDetails = i + 1 < path.length ? path[i + 1] : null;
      int totalTime = edgeDetails.edgeTimeEnd.toInt();
      DateTime startTime = initialTime.add(Duration(minutes: edgeDetails.edgeTimeStart.toInt()));
      DateTime arrivalTime = initialTime.add(Duration(minutes: totalTime));

      bool isLast = nextEdgeDetails == null;
      if (isLast) {
        story.add(ArrivalAction(targetVertex: edgeDetails.transitEdge.targetVertex, totalTime: totalTime, arrivalTime: arrivalTime));
        break;
      }

      bool isStart = previousEdgeDetails == null;
      if (isStart) {
        story.add(StartAction(sourceVertex: edgeDetails.transitEdge.sourceVertex, startTime: initialTime));
      }

      bool isWalking = edgeDetails.transitEdge is WalkEdge;
      if (isWalking) {
        story.add(WalkAction(
          sourceVertex: edgeDetails.transitEdge.sourceVertex,
          targetVertex: edgeDetails.transitEdge.targetVertex,
          totalTime: totalTime,
          startTime: startTime,
          arrivalTime: arrivalTime,
        ));
      }

      bool isVehicle = edgeDetails.transitEdge is VehicleEdge;
      if (isVehicle) {
        VehicleEdge currentVehicleEdge = edgeDetails.transitEdge as VehicleEdge;
        bool isPreviousVehicle = previousEdgeDetails?.transitEdge is VehicleEdge;
        if (isPreviousVehicle) {
          VehicleEdge previousVehicleEdge = previousEdgeDetails!.transitEdge as VehicleEdge;
          bool isTransit = currentVehicleEdge.trackId != previousVehicleEdge.trackId;
          if (isTransit) {
            story.add(LeaveVehicleAction(stopVertex: previousVehicleEdge.targetVertex, leaveTrackId: previousVehicleEdge.trackId));
          } else {
            story.add(TripAction(
              sourceVertex: edgeDetails.transitEdge.sourceVertex,
              targetVertex: edgeDetails.transitEdge.targetVertex,
              totalTime: totalTime,
              startTime: startTime,
              arrivalTime: arrivalTime,
              trackId: currentVehicleEdge.trackId,
            ));
            continue;
          }
        }
        story.add(WaitAction(
          stopVertex: edgeDetails.transitEdge.sourceVertex,
          waitTime: edgeDetails.fullTime.waitingTime.toInt(),
        ));

        startTime = startTime.add(Duration(minutes: edgeDetails.fullTime.waitingTime.toInt()));
        story.add(EnterVehicleAction(
          stopVertex: edgeDetails.transitEdge.sourceVertex,
          trackId: currentVehicleEdge.trackId,
          time: startTime,
        ));

        story.add(TripAction(
          sourceVertex: edgeDetails.transitEdge.sourceVertex,
          targetVertex: edgeDetails.transitEdge.targetVertex,
          totalTime: edgeDetails.fullTime.transitTime.toInt(),
          startTime: startTime,
          arrivalTime: arrivalTime,
          trackId: currentVehicleEdge.trackId,
        ));
      }
    }
    return story;
  }
}

abstract class PathfinderResultStoryAction {}

class StartAction extends PathfinderResultStoryAction {
  final StopVertex sourceVertex;
  final DateTime startTime;

  StartAction({
    required this.sourceVertex,
    required this.startTime,
  });

  @override
  String toString() {
    return 'StartAction{sourceVertex: ${sourceVertex.name}, startTime: $startTime}';
  }
}

class ArrivalAction extends PathfinderResultStoryAction {
  final StopVertex targetVertex;
  final DateTime arrivalTime;
  final int totalTime;

  ArrivalAction({
    required this.targetVertex,
    required this.arrivalTime,
    required this.totalTime,
  });

  @override
  String toString() {
    return 'ArrivalAction{targetVertex: ${targetVertex.name}, arrivalTime: $arrivalTime, totalTime: $totalTime}';
  }
}

class WalkAction extends PathfinderResultStoryAction {
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final DateTime startTime;
  final DateTime arrivalTime;
  final int totalTime;

  WalkAction({
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
    required this.arrivalTime,
    required this.totalTime,
  });

  @override
  String toString() {
    return 'WalkAction{sourceVertex: ${sourceVertex.name}, targetVertex: ${targetVertex.name}, startTime: $startTime, arrivalTime: $arrivalTime, totalTime: $totalTime}';
  }
}

class LeaveVehicleAction extends PathfinderResultStoryAction {
  final StopVertex stopVertex;
  final String leaveTrackId;

  LeaveVehicleAction({
    required this.stopVertex,
    required this.leaveTrackId,
  });

  @override
  String toString() {
    return 'LeaveVehicleAction{stopVertex: ${stopVertex.name}, leaveTrackId: $leaveTrackId}';
  }
}

class TripAction extends PathfinderResultStoryAction {
  final StopVertex sourceVertex;
  final StopVertex targetVertex;
  final DateTime startTime;
  final DateTime arrivalTime;
  final int totalTime;
  final String trackId;

  TripAction({
    required this.sourceVertex,
    required this.targetVertex,
    required this.startTime,
    required this.arrivalTime,
    required this.totalTime,
    required this.trackId,
  });

  @override
  String toString() {
    return 'TripAction{sourceVertex: ${sourceVertex.name}, targetVertex: ${targetVertex.name}, startTime: $startTime, arrivalTime: $arrivalTime, totalTime: $totalTime, trackId: $trackId}';
  }
}

class WaitAction extends PathfinderResultStoryAction {
  final StopVertex stopVertex;
  final int waitTime;

  WaitAction({
    required this.stopVertex,
    required this.waitTime,
  });

  @override
  String toString() {
    return 'WaitAction{stopVertex: ${stopVertex.name}, waitTime: $waitTime}';
  }
}

class EnterVehicleAction extends PathfinderResultStoryAction {
  final StopVertex stopVertex;
  final String trackId;
  final DateTime time;

  EnterVehicleAction({
    required this.stopVertex,
    required this.trackId,
    required this.time,
  });

  @override
  String toString() {
    return 'EnterVehicleAction{stopVertex: ${stopVertex.name}, trackId: $trackId, time: $time}';
  }
}
