class WalkingTableConfigModel {
  final String penaltyFunction;
  final double guaranteedPenaltyForTransfer;
  final int weight;
  final int speed;
  
  WalkingTableConfigModel({
    required this.penaltyFunction,
    required this.guaranteedPenaltyForTransfer,
    required this.weight,
    required this.speed,
  });
  
  WalkingTableConfigModel copyWith({
    String? penaltyFunction,
    double? guaranteedPenaltyForTransfer,
    int? weight,
    int? speed,
  }) {
    return WalkingTableConfigModel(
      penaltyFunction: penaltyFunction ?? this.penaltyFunction,
      guaranteedPenaltyForTransfer: guaranteedPenaltyForTransfer ?? this.guaranteedPenaltyForTransfer,
      weight: weight ?? this.weight,
      speed: speed ?? this.speed,
    );
  }
}