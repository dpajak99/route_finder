import 'package:equatable/equatable.dart';

abstract class TransitEdgeEntity extends Equatable {
  final int from;
  final int to;

  const TransitEdgeEntity({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => <Object?>[from, to];
}
