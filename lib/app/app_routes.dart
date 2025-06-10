import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/screens/splash_screen.dart';
import 'package:mindfulminis/features/analytices/screens/analytic_screen.dart';
import 'package:mindfulminis/features/authentication/screens/auth_main.dart';
import 'package:mindfulminis/features/authentication/screens/phone_verification.dart';
import 'package:mindfulminis/features/breathing/screens/breathing_screen.dart';
import 'package:mindfulminis/features/forgot_password/screens/forgot_password.dart';
import 'package:mindfulminis/features/journal/screens/create_journal_screen.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail_screen.dart';
import 'package:mindfulminis/features/login/screens/login.dart';
import 'package:mindfulminis/features/meditation/screens/meditation_screen.dart';
import 'package:mindfulminis/features/onbaord/screens/dob.dart';
import 'package:mindfulminis/features/onbaord/screens/felling_today.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/features/onboarding/screens/onboard_screen.dart';
import 'package:mindfulminis/features/play%20visuals/screen/play_visuals.dart';
import 'package:mindfulminis/features/profile/screens/app_setting_screen.dart';
import 'package:mindfulminis/features/profile/screens/edit_profile_screen.dart';
import 'package:mindfulminis/features/profile/screens/language_screen.dart';
import 'package:mindfulminis/features/routine/screens/affirmation_screen.dart';
import 'package:mindfulminis/features/routine/screens/create_routine_screen.dart';
import 'package:mindfulminis/features/routine/screens/my_routine_screen.dart';
import 'package:mindfulminis/features/routine/screens/routine_detail_screen.dart';
import 'package:mindfulminis/features/signup/screens/create_account.dart';
import 'package:mindfulminis/features/stories/screens/stories_download.dart';
import 'package:mindfulminis/features/stories/screens/stories_screen.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/features/yoga/screens/yoga_list.dart';
import 'package:mindfulminis/features/yoga/screens/yoga_main.dart';

import '../features/about/screens/about_screen.dart';
import '../features/help_center/screens/help_center_screen.dart';
import '../features/library/screens/library_screen.dart';
import '../features/onbaord/screens/describe_yourself.dart';
import '../features/privacy/screens/privacy_screen.dart';
import '../features/referals/screens/referal_screen.dart';
import '../features/sidhi/screens/shidi_chat_screen.dart';
import '../features/terms_service/screens/terms_service.dart';

// GoRouter configuration
GoRouter buildRouter() {
  return GoRouter(
    routes: [
      // GoRoute(path: '/', name: '/', builder: (context, state) => TabView()),
      GoRoute(
        path: SplashScreen.routePath,
        name: SplashScreen.routeName,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: OnboardScreen.routePath,
        name: OnboardScreen.routeName,
        builder: (context, state) => OnboardScreen(),
      ),
      GoRoute(
        name: AuthMain.routeName,
        path: AuthMain.routePath,
        builder: (context, state) => AuthMain(),
      ),
      GoRoute(
        name: PhoneVerification.routeName,
        path: PhoneVerification.routePath,
        builder: (context, state) => PhoneVerification(),
      ),
      GoRoute(
        name: Login.routeName,
        path: Login.routePath,
        builder: (context, state) => Login(),
      ),
      GoRoute(
        name: CreateAccount.routeName,
        path: CreateAccount.routePath,
        builder: (context, state) => CreateAccount(),
      ),
      GoRoute(
        name: ForgotPassword.routeName,
        path: ForgotPassword.routePath,
        builder: (context, state) => ForgotPassword(),
      ),
      GoRoute(
        path: KidName.routePath,
        name: KidName.routeName,
        builder: (context, state) => KidName(),
      ),
      GoRoute(
        path: Dob.routePath,
        name: Dob.routeName,
        builder: (context, state) => Dob(),
      ),
      GoRoute(
        path: FellingToday.routePath,
        name: FellingToday.routeName,
        builder: (context, state) => FellingToday(),
      ),
      GoRoute(
        path: DescribeYourself.routePath,
        name: DescribeYourself.routeName,
        builder: (context, state) => DescribeYourself(),
      ),
      GoRoute(
        path: TabView.routePath,
        name: TabView.routeName,
        builder: (context, state) => TabView(),
      ),
      GoRoute(
        path: EditProfileScreen.routePath,
        name: EditProfileScreen.routeName,
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: AppSettingScreen.routePath,
        name: AppSettingScreen.routeName,
        builder: (context, state) => AppSettingScreen(),
      ),
      GoRoute(
        path: LanguageScreen.routePath,
        name: LanguageScreen.routeName,
        builder: (context, state) => LanguageScreen(),
      ),
      GoRoute(
        path: CreateJournalScreen.routePath,
        name: CreateJournalScreen.routeName,
        builder: (context, state) => CreateJournalScreen(),
      ),
      GoRoute(
        path: JournalDetailScreen.routePath,
        name: JournalDetailScreen.routeName,
        builder: (context, state) => JournalDetailScreen(),
      ),
      GoRoute(
        path: CreateRoutineScreen.routePath,
        name: CreateRoutineScreen.routeName,
        builder: (context, state) => CreateRoutineScreen(),
      ),
      GoRoute(
        path: MyRoutineScreen.routePath,
        name: MyRoutineScreen.routeName,
        builder: (context, state) => MyRoutineScreen(),
      ),
      GoRoute(
        path: RoutineDetailScreen.routePath,
        name: RoutineDetailScreen.routeName,
        builder: (context, state) => RoutineDetailScreen(),
      ),
      GoRoute(
        path: YogaMain.routePath,
        name: YogaMain.routeName,
        builder: (context, state) => YogaMain(),
      ),
      GoRoute(
        path: YogaList.routePath,
        name: YogaList.routeName,
        builder: (context, state) => YogaList(),
      ),
      GoRoute(
        path: MeditationScreen.routePath,
        name: MeditationScreen.routeName,
        builder: (context, state) => MeditationScreen(),
      ),
      GoRoute(
        path: StoriesScreen.routePath,
        name: StoriesScreen.routeName,
        builder: (context, state) => StoriesScreen(),
      ),
      GoRoute(
        path: BreathingScreen.routePath,
        name: BreathingScreen.routeName,
        builder: (context, state) => BreathingScreen(),
      ),
      GoRoute(
        path: PlayVisuals.routePath,
        name: PlayVisuals.routeName,
        builder: (context, state) => PlayVisuals(),
      ),
      GoRoute(
        path: StoriesDownload.routePath,
        name: StoriesDownload.routeName,
        builder: (context, state) => StoriesDownload(),
      ),
      GoRoute(
        path: ShidiChatScreen.routePath,
        name: ShidiChatScreen.routeName,
        builder: (context, state) => ShidiChatScreen(),
      ),

      GoRoute(
        path: AnalyticScreen.routePath,
        name: AnalyticScreen.routeName,
        builder: (context, state) => AnalyticScreen(),
      ),
      GoRoute(
        path: AffirmationScreen.routePath,
        name: AffirmationScreen.routeName,
        builder: (context, state) => AffirmationScreen(),
      ),
      GoRoute(
        path: HelpCenterScreen.routePath,
        name: HelpCenterScreen.routeName,
        builder: (context, state) => HelpCenterScreen(),
      ),
      GoRoute(
        path: TermsService.routePath,
        name: TermsService.routeName,
        builder: (context, state) => TermsService(),
      ),
      GoRoute(
        path: ReferalScreen.routePath,
        name: ReferalScreen.routeName,
        builder: (context, state) => ReferalScreen(),
      ),
      GoRoute(
        path: LibraryScreen.routePath,
        name: LibraryScreen.routeName,
        builder: (context, state) => LibraryScreen(),
      ),
      GoRoute(
        path: PrivacyScreen.routePath,
        name: PrivacyScreen.routeName,
        builder: (context, state) => PrivacyScreen(),
      ),

      GoRoute(
        path: AboutScreen.routePath,
        name: AboutScreen.routeName,
        builder: (context, state) => AboutScreen(),
      ),
    ],
    // redirect: (context, state) {
    //   return TabView.routePath;
    // },
    observers: [FlutterSmartDialog.observer],
  );
}
