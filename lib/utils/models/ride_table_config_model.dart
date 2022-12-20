class RideTableConfigModel {
  final double penaltyForTransfer;
  final double penaltyWeight;
  final double waitingTimeWeight;

  RideTableConfigModel({
    required this.penaltyForTransfer,
    required this.penaltyWeight,
    required this.waitingTimeWeight,
  });

  RideTableConfigModel copyWith({
    double? penaltyForTransfer,
    double? penaltyWeight,
    double? waitingTimeWeight,
  }) {
    return RideTableConfigModel(
      penaltyForTransfer: penaltyForTransfer ?? this.penaltyForTransfer,
      penaltyWeight: penaltyWeight ?? this.penaltyWeight,
      waitingTimeWeight: waitingTimeWeight ?? this.waitingTimeWeight,
    );
  }
}