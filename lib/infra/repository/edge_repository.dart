import 'package:path_finder/infra/entity/transit_edge_entity.dart';

abstract class EdgeRepository {
  Future<List<TransitEdgeEntity>> getAll();
}