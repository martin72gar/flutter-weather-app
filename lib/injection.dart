import 'package:course_weather_forecast/commons/app_session.dart';
import 'package:course_weather_forecast/features/pick_place/presentation/cubit/city_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  // cubit / bloc
  locator.registerFactory(() => CityCubit(locator()));

  //external
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => AppSession(pref));
}
