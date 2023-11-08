import 'package:equatable/equatable.dart';

class Distance extends Equatable {
  static Distance zero = Distance(meters: 0);
  final double distanceInMeters;

  factory Distance({
    num? millimeters,
    num? centimeters,
    num? meters,
    num? kilometers,
  }) {
    double totalDistance = 0;
    if (millimeters != null) {
      totalDistance += millimeters / 1000;
    }
    if (centimeters != null) {
      totalDistance += centimeters / 100;
    }
    if (meters != null) {
      totalDistance += meters;
    }
    if (kilometers != null) {
      totalDistance += kilometers * 1000;
    }
    return Distance._(distanceInMeters: totalDistance);
  }
  
  const Distance._({
    required this.distanceInMeters,
  });
  
  double get inKilometers => distanceInMeters / 1000;
  
  double get inMeters => distanceInMeters;
  
  double get inCentimeters => distanceInMeters * 100;
  
  double get inMillimeters => distanceInMeters * 1000;
  
  Distance operator +(Distance other) {
    return Distance(meters: distanceInMeters + other.distanceInMeters);
  }
  
  Distance operator -(Distance other) {
    return Distance(meters: distanceInMeters - other.distanceInMeters);
  }
  
  Distance operator *(double other) {
    return Distance(meters: distanceInMeters * other);
  }
  
  Distance operator /(double other) {
    return Distance(meters: distanceInMeters / other);
  }
  
  @override
  String toString() {
    if(inKilometers >= 1) {
      return '${inKilometers.toStringAsFixed(2)} km';
    } else if(inMeters >= 1) {
      return '${inMeters.toStringAsFixed(2)} m';
    } else if(inCentimeters >= 1) {
      return '${inCentimeters.toStringAsFixed(2)} cm';
    } else {
      return '${inMillimeters.toStringAsFixed(2)} mm';
    }
  }
  
  @override
  List<Object?> get props => <Object>[distanceInMeters];
}
