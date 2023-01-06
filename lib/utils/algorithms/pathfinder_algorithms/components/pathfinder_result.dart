import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_state.dart';
import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/algorithms/pathfinder_algorithms/components/pathfinder_algoritm_result.dart';
import 'package:path_finder/utils/models/distance.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/utils/time_utils.dart';

class PathfinderResult {
  final DateTime initialTime;
  final DateTime searchStartTime;
  final DateTime searchEndTime;
  final int visitedStopsCount;
  final List<EdgeDetails> path;
  final List<StopVertex> visitedStopsHistory;
  final PathfinderSettingsState pathfinderSettingsState;

  factory PathfinderResult({
    required PathfinderAlgorithmResult pathfinderAlgorithmResult,
    required List<EdgeDetails> path,
    required DateTime initialTime,
    required PathfinderSettingsState pathfinderSettingsState,
  }) {
    return PathfinderResult._(
      initialTime: initialTime,
      searchStartTime: pathfinderAlgorithmResult.algorithmStartTime,
      searchEndTime: DateTime.now(),
      visitedStopsCount: pathfinderAlgorithmResult.visitedStopsCount,
      path: path,
      visitedStopsHistory: pathfinderAlgorithmResult.visitedStopsHistory,
      pathfinderSettingsState: pathfinderSettingsState,
    );
  }

  PathfinderResult._({
    required this.initialTime,
    required this.searchStartTime,
    required this.searchEndTime,
    required this.visitedStopsCount,
    required this.path,
    required this.visitedStopsHistory,
    required this.pathfinderSettingsState,
  });

  List<String> get logs {
    return <String>[
      'Pathfinder v.1.0.0',
      'Algorithm: ${pathfinderSettingsState.algorithmType}',
      '----',
      'Source: ${pathfinderSettingsState.sourceVertex!.name}',
      'Target: ${pathfinderSettingsState.targetVertex!.name}',
      '----',
      'Visited stops count: ${visitedStopsCount}',
      'Total transfers: ${totalTransfersCount}',
      'Total walks: ${totalWalksCount}',
      '----',
      'Total walk distance: ${totalWalkDistance}',
      'Total trip distance: ${totalTripDistance}',
      '----',
      'Trip start time: ${pathfinderSettingsState.searchDateTime}',
      'Trip end time: ${tripEndTime}',
      'Trip duration: ${TimeUtils.minutesToString(tripDuration.inMinutes)}',
      '----',
      'Search start time: ${searchStartTime}',
      'Search end time: ${searchEndTime}',
      'Search duration: ${TimeUtils.millisecondsToString(searchDuration.inMilliseconds)}',
    ];
  }

  DateTime get tripEndTime {
    return pathfinderSettingsState.searchDateTime.add(Duration(minutes: path.last.edgeTimeEnd.toInt()));
  }

  Duration get tripDuration {
    return tripEndTime.difference(pathfinderSettingsState.searchDateTime);
  }

  Duration get searchDuration {
    return searchEndTime.difference(searchStartTime);
  }

  int get totalTransfersCount {
    Set<String> trackIds = <String>{};
    for (EdgeDetails edgeDetails in path) {
      if (edgeDetails.transitEdge is VehicleEdge) {
        VehicleEdge vehicleEdge = edgeDetails.transitEdge as VehicleEdge;
        trackIds.add(vehicleEdge.trackId);
      }
    }
    return trackIds.length - 1;
  }

  int get totalWalksCount {
    int walksCount = 0;
    for (EdgeDetails edgeDetails in path) {
      if (edgeDetails.transitEdge is WalkEdge) {
        walksCount++;
      }
    }
    return walksCount;
  }

  Distance get totalWalkDistance {
    Distance distance = Distance.zero;
    for (EdgeDetails edgeDetails in path) {
      if (edgeDetails.transitEdge is WalkEdge) {
        WalkEdge walkEdge = edgeDetails.transitEdge as WalkEdge;
        distance += walkEdge.distance;
      }
    }
    return distance;
  }
  
  Distance get totalTripDistance {
    Distance distance = Distance.zero;
    for (EdgeDetails edgeDetails in path) {
      if (edgeDetails.transitEdge is WalkEdge) {
        WalkEdge walkEdge = edgeDetails.transitEdge as WalkEdge;
        distance += walkEdge.distance;
      } else {
        VehicleEdge vehicleEdge = edgeDetails.transitEdge as VehicleEdge;
        distance += Haversine.calcDistance(vehicleEdge.sourceVertex.latLng, vehicleEdge.targetVertex.latLng);
      }
    }
    return distance;
  }
}
