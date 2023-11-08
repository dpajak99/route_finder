import 'package:path_finder/utils/models/edge_details.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';
import 'package:path_finder/views/pages/map/markers/stop_marker/stop_marker.dart';
import 'package:path_finder/views/pages/map/markers/transit_stop_marker/transit_stop_marker_widget.dart';

class TransitStopMarker extends StopMarker {
  final EdgeDetails edgeDetails;

  TransitStopMarker({required this.edgeDetails, required StopVertex stopVertex, required bool isLast})
      : super(
          stopVertex: stopVertex,
          width: 300,
          height: 150,
          builder: (_) => TransitStopMarkerWidget(edgeDetails: edgeDetails, stopVertex: stopVertex, isLast: isLast),
        );
}
