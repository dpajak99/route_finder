import 'package:path_finder/utils/models/edge_result.dart';
import 'package:path_finder/utils/models/markers/stop_marker.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/views/pages/transit_stop_marker_widget.dart';

class TransitStopMarker extends StopMarker {
  final TransitEdgeResult transitEdgeResult;

  TransitStopMarker({required this.transitEdgeResult, required StopVertex stopVertex, required bool isLast})
      : super(
          stopVertex: stopVertex,
          width: 300,
          height: 150,
          builder: (_) => TransitStopMarkerWidget(transitEdgeResult: transitEdgeResult, stopVertex: stopVertex, isLast: isLast),
        );
}
