import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class GetDirectionsRequest extends Equatable {
  final StopVertex origin;
  final StopVertex destination;
  final String travelMode;
  final String units;
  final bool computeAlternativeRoutes;

  const GetDirectionsRequest({
    required this.origin,
    required this.destination,
    this.travelMode = 'WALK',
    this.units = 'METRIC',
    this.computeAlternativeRoutes = false,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'origin': <String, dynamic>{
        'location': <String, dynamic>{
          'latLng': <String, dynamic>{
            'latitude': origin.latLng.latitude,
            'longitude': origin.latLng.longitude,
          },
        },
      },
      'destination': <String, dynamic>{
        'location': <String, dynamic>{
          'latLng': <String, dynamic>{
            'latitude': destination.latLng.latitude,
            'longitude': destination.latLng.longitude,
          },
        },
      },
      'travelMode': travelMode,
      'units': units,
      'computeAlternativeRoutes': computeAlternativeRoutes,
    };
  }

  @override
  List<Object?> get props => <Object?>[origin, destination, travelMode, units, computeAlternativeRoutes];
}
