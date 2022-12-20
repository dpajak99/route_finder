class GlobalTableConfigModel {
  final double transitTimeWeight;
  final double distanceWeight;

  GlobalTableConfigModel({
    required this.transitTimeWeight,
    required this.distanceWeight,
  });

  GlobalTableConfigModel copyWith({
    double? transitTimeWeight,
    double? distanceWeight,
  }) {
    return GlobalTableConfigModel(
      transitTimeWeight: transitTimeWeight ?? this.transitTimeWeight,
      distanceWeight: distanceWeight ?? this.distanceWeight,
    );
  }
}