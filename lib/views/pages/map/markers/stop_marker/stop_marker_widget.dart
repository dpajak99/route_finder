import 'package:flutter/material.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/config/locator.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopMarkerWidget extends StatelessWidget {
  final StopVertex stopVertex;

  const StopMarkerWidget({
    required this.stopVertex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final StopSelectCubit stopSelectCubit = getIt<StopSelectCubit>();
    
    return GestureDetector(
      onTap: () {
        stopSelectCubit.updateSelectedVertex(stopVertex);
      },
      child: const Icon(Icons.location_on),
    );
  }
}
