
import 'package:get_it/get_it.dart';
import 'package:path_finder/bloc/console_cubit/console_cubit.dart';
import 'package:path_finder/bloc/map/map_cubit.dart';
import 'package:path_finder/bloc/pathfinder_cubit/pathfinder_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/infra/repository/assets/assets_edge_repository.dart';
import 'package:path_finder/infra/repository/assets/assets_google_repository.dart';
import 'package:path_finder/infra/repository/assets/assets_stop_repository.dart';
import 'package:path_finder/infra/repository/edge_repository.dart';
import 'package:path_finder/infra/repository/google_repository.dart';
import 'package:path_finder/infra/repository/postgres/postgres_edge_repository.dart';
import 'package:path_finder/infra/repository/postgres/postgres_stop_repository.dart';
import 'package:path_finder/infra/repository/stop_repository.dart';
import 'package:path_finder/infra/service/graph_service.dart';
import 'package:path_finder/infra/service/stop_service.dart';

final GetIt getIt = GetIt.instance;

void initLocator() {
  getIt.registerLazySingleton<PathFinderCubit>(PathFinderCubit.new);
  getIt.registerLazySingleton<PathfinderSettingsCubit>(PathfinderSettingsCubit.new);
  getIt.registerLazySingleton<StopSelectCubit>(StopSelectCubit.new);
  getIt.registerLazySingleton<MapCubit>(MapCubit.new);
  getIt.registerLazySingleton<ConsoleCubit>(ConsoleCubit.new);
  
  getIt.registerLazySingleton<StopRepository>(AssetsStopRepository.new);
  getIt.registerLazySingleton<StopService>(StopService.new);
  getIt.registerLazySingleton<EdgeRepository>(AssetsEdgeRepository.new);
  getIt.registerLazySingleton<GraphService>(GraphService.new);
  getIt.registerLazySingleton<GoogleRepository>(AssetsGoogleRepository.new);
}