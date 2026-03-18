import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/router/app_routes.dart';
import 'package:mindfulminis/core/services/auth_service.dart';
import 'package:mindfulminis/core/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/data/cms_data.dart';
import '../../common/data/discover_data.dart';
import '../../features/authentication/auth_data/auth_data.dart';
import '../../features/breathing/data/breathing_data.dart';
import '../../features/breathing/providers/breathing_provider.dart';
import '../../features/home/data/home_data.dart';
import '../../features/journal/journal_data/journal_data.dart';
import '../../features/onbaord/onboard_data/onboard_data.dart';
import '../../features/profile/profile_data/profile_data.dart';
import '../../features/routine/routine_data/routine_data.dart';
import '../../features/routine/providers/activities_provider.dart';
import '../../features/meditation/data/meditation_data.dart';
import '../../features/meditation/providers/meditation_provider.dart';
import '../../features/stories/data/stories_data.dart';
import '../../features/stories/proviers/sroties_provider.dart';
import '../../features/yoga/data/yoga_data.dart';
import '../../features/yoga/providers/yoga_provider.dart';
import '../services/image_picker_helper.dart';
import '../services/shared_prefs.dart';
import '../services/upload_file_service.dart';

final sl = GetIt.instance; // Ensure you're using the correct GetIt instance

Future<void> setupInjection() async {
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  //router
  sl.registerSingleton<GoRouter>(buildRouter());

  //services
  sl.registerLazySingleton<AuthService>(() => AuthService());
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
  sl.registerLazySingleton<YogaData>(() => YogaData(httpService: sl()));
  sl.registerLazySingleton<MeditationData>(
    () => MeditationData(httpService: sl()),
  );
  sl.registerLazySingleton<BreathingData>(
    () => BreathingData(httpService: sl()),
  );
  sl.registerLazySingleton<StoriesData>(() => StoriesData(httpService: sl()));
  sl.registerLazySingleton<DiscoverData>(
    () => DiscoverData(httpService: sl()),
  );

  //providers
  sl.registerLazySingleton<ActivitiesProvider>(() => ActivitiesProvider());
  sl.registerLazySingleton<YogaProvider>(() => YogaProvider(yogaData: sl()));
  sl.registerLazySingleton<MeditationProvider>(
    () => MeditationProvider(meditationData: sl()),
  );
  sl.registerLazySingleton<BreathingProvider>(
    () => BreathingProvider(breathingData: sl()),
  );
  sl.registerLazySingleton<SrotiesProvider>(
    () => SrotiesProvider(storiesData: sl()),
  );
}
