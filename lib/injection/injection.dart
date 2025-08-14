import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/app/app_routes.dart';
import 'package:mindfulminis/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentication/auth_data/auth_data.dart';
import '../features/journal/journal_data/journal_data.dart';
import '../features/onbaord/onboard_data/onboard_data.dart';
import '../features/profile/profile_data/profile_data.dart';
import '../features/routine/routine_data/routine_data.dart';
import '../services/image_picker_helper.dart';
import '../services/shared_prefs.dart';

final sl = GetIt.instance; // Ensure you're using the correct GetIt instance

Future<void> setupInjection() async {
  
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  //router
  sl.registerSingleton<GoRouter>(buildRouter());

  //services
  sl.registerLazySingleton(() => SharedPrefs(prefs: sl()));
  sl.registerLazySingleton<HttpService>(() => HttpService());
  sl.registerLazySingleton<ImagePickerHelper>(() => ImagePickerHelper());

  //data sources
  sl.registerLazySingleton<AuthData>(() => AuthData(httpService: sl()));
  sl.registerLazySingleton<ProfileData>(() => ProfileData(httpService: sl()));
  sl.registerLazySingleton<OnboardData>(() => OnboardData(httpService: sl()));
  sl.registerLazySingleton<RoutineData>(() => RoutineData(httpService: sl()));
  sl.registerLazySingleton<JournalData>(() => JournalData(httpService: sl()));
}
