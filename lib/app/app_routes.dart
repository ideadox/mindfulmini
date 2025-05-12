import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/screens/splash_screen.dart';
import 'package:mindfulminis/features/authentication/screens/auth_main.dart';
import 'package:mindfulminis/features/authentication/screens/phone_verification.dart';
import 'package:mindfulminis/features/forgot_password/screens/forgot_password.dart';
import 'package:mindfulminis/features/login/screens/login.dart';
import 'package:mindfulminis/features/onbaord/screens/dob.dart';
import 'package:mindfulminis/features/onbaord/screens/felling_today.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/features/onboarding/screens/onboard_screen.dart';
import 'package:mindfulminis/features/profile/screens/app_setting_screen.dart';
import 'package:mindfulminis/features/profile/screens/edit_profile_screen.dart';
import 'package:mindfulminis/features/profile/screens/language_screen.dart';
import 'package:mindfulminis/features/signup/screens/create_account.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';

import '../features/onbaord/screens/describe_yourself.dart';

// GoRouter configuration
GoRouter buildRouter() {
  return GoRouter(
    routes: [
      GoRoute(path: '/', name: '/', builder: (context, state) => TabView()),
      // GoRoute(
      //   path: SplashScreen.routePath,
      //   name: SplashScreen.routeName,
      //   builder: (context, state) => SplashScreen(),
      // ),
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
    ],
    // redirect: (context, state) {
    //   return TabView.routePath;
    // },
    observers: [FlutterSmartDialog.observer],
  );
}
