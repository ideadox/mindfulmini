import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/app/app_routes.dart';
import 'package:mindfulminis/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/data/cms_data.dart';
import '../features/authentication/auth_data/auth_data.dart';
import '../features/home/data/home_data.dart';
import '../features/journal/journal_data/journal_data.dart';
import '../features/onbaord/onboard_data/onboard_data.dart';
import '../features/profile/profile_data/profile_data.dart';
import '../features/routine/routine_data/routine_data.dart';
import '../services/image_picker_helper.dart';
import '../services/shared_prefs.dart';
import '../services/storage/flutter_secure_token_storage.dart';
import '../services/storage/token_storage.dart';
import '../services/upload_file_service.dart';

final sl = GetIt.instance; // Ensure you're using the correct GetIt instance

Future<void> setupInjection() async {
  sl.registerLazySingleton<TokenStorage>(() => FlutterSecureTokenStorage());
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  //router
  sl.registerSingleton<GoRouter>(buildRouter());

  //services
  sl.registerLazySingleton(() => SharedPrefs(prefs: sl()));
  sl.registerLazySingleton<HttpService>(() => HttpService());
  sl.registerLazySingleton<ImagePickerHelper>(() => ImagePickerHelper());
  sl.registerLazySingleton<UploadFileService>(() => UploadFileService());

  //data sources
  sl.registerLazySingleton<AuthData>(() => AuthData(httpService: sl()));
  sl.registerLazySingleton<ProfileData>(() => ProfileData(httpService: sl()));
  sl.registerLazySingleton<OnboardData>(() => OnboardData(httpService: sl()));
  sl.registerLazySingleton<RoutineData>(() => RoutineData(httpService: sl()));
  sl.registerLazySingleton<JournalData>(() => JournalData(httpService: sl()));
  sl.registerLazySingleton<HomeData>(() => HomeData(httpService: sl()));
  sl.registerLazySingleton<CmsData>(() => CmsData(httpService: sl()));
}
