import 'package:equatable/equatable.dart';

class Vertex extends Equatable {
  final String id;

  const Vertex({
    required this.id,
  });
  
  @override
  List<Object?> get props => <Object?>[id];
}
