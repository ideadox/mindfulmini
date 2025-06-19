import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/app/app_routes.dart';
import 'package:mindfulminis/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/authentication/auth_data/auth_data.dart';
import '../features/profile/profile_data/profile_data.dart';
import '../services/shared_prefs.dart';

final sl = GetIt.instance; // Ensure you're using the correct GetIt instance

Future<void> setupInjection() async {
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  sl.registerSingleton<GoRouter>(buildRouter());

  sl.registerLazySingleton(() => SharedPrefs(prefs: sl()));
  sl.registerLazySingleton<HttpService>(() => HttpService());

  sl.registerLazySingleton<AuthData>(() => AuthData(httpService: sl()));
  sl.registerLazySingleton<ProfileData>(() => ProfileData(httpService: sl()));
}
