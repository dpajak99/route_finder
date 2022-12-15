import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopMarkerWidget extends StatelessWidget {
  final StopVertex stopVertex;
  
  const StopMarkerWidget({
    required this.stopVertex,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.location_on);
  }
}