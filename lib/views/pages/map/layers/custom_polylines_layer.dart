import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_finder/bloc/map/map_polylines_cubit/map_polylines_cubit.dart';
import 'package:path_finder/bloc/map/map_polylines_cubit/map_polylines_state.dart';

class CustomPolylineLayer extends StatelessWidget {
  final MapPolylinesCubit mapPolylinesCubit;

  const CustomPolylineLayer({
    required this.mapPolylinesCubit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapPolylinesCubit, MapPolylinesState>(
      bloc: mapPolylinesCubit,
      builder: (BuildContext context, MapPolylinesState mapPolylinesState) {
        return PolylineLayer(
          polylines: mapPolylinesState.visible ? mapPolylinesState.polylines.toList() : <Polyline>[],
        );
      },
    );
  }
}
