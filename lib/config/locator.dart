
import 'package:get_it/get_it.dart';
import 'package:path_finder/bloc/map/map_cubit.dart';
import 'package:path_finder/bloc/pathfinder_cubit/pathfinder_cubit.dart';
import 'package:path_finder/bloc/pathfinder_settings_cubit/pathfinder_settings_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';

final GetIt getIt = GetIt.instance;

void initLocator() {
  getIt.registerLazySingleton<PathFinderCubit>(PathFinderCubit.new);
  getIt.registerLazySingleton<PathfinderSettingsCubit>(PathfinderSettingsCubit.new);
  getIt.registerLazySingleton<StopSelectCubit>(StopSelectCubit.new);
  getIt.registerLazySingleton<MapCubit>(MapCubit.new);
}