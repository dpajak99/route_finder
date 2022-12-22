
import 'package:get_it/get_it.dart';
import 'package:path_finder/listeners/edge_cost_config/edge_cost_config.dart';

final GetIt getIt = GetIt.instance;

void initLocator() {
  getIt.registerLazySingleton<EdgeCostConfig>(EdgeCostConfig.new);
}