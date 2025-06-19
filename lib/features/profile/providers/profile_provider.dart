import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/about/screens/about_screen.dart';
import 'package:mindfulminis/features/analytices/screens/analytic_screen.dart';
import 'package:mindfulminis/features/help_center/screens/help_center_screen.dart';
import 'package:mindfulminis/features/profile/screens/app_setting_screen.dart';
import 'package:mindfulminis/features/profile/screens/language_screen.dart';
import 'package:mindfulminis/features/referals/screens/referal_screen.dart';
import 'package:mindfulminis/features/subscription/screens/manage_subscription.dart';
import 'package:mindfulminis/features/terms_service/screens/terms_service.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:mindfulminis/services/shared_prefs.dart';

import '../../library/screens/library_screen.dart';
import '../../privacy/screens/privacy_screen.dart';
import '../profile_data/profile_data.dart';
import '../screens/edit_profile_screen.dart';

class ProfileProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final _profileData = sl<ProfileData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();

  late String? userId;
  ProfileProvider() {
    userId = _sharedPrefs.getUserId();
    getUser();
  }
  Future<void> getUser() async {
    try {
      _profileData.getUser(userId ?? '');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  void navigateToEditProfile() {
    _navigationService.pushNamed(EditProfileScreen.routeName);
    return;
  }

  void navigateToAnalytices() {
    _navigationService.pushNamed(AnalyticScreen.routeName);
    return;
  }

  void navigateToSubscrption() {
    _navigationService.pushNamed(ManageSubscription.routeName);
    return;
  }

  void navigateToAppSetting() {
    _navigationService.pushNamed(AppSettingScreen.routeName);
    return;
  }

  void navigateToLanguage() {
    _navigationService.pushNamed(LanguageScreen.routeName);
    return;
  }

  void navigateToHelpCenter() {
    _navigationService.pushNamed(HelpCenterScreen.routeName);
    return;
  }

  void navigateToTermsService() {
    _navigationService.pushNamed(TermsService.routeName);
    return;
  }

  void navigateToReferal() {
    _navigationService.pushNamed(ReferalScreen.routeName);
    return;
  }

  void navigateToLibrary() {
    _navigationService.pushNamed(LibraryScreen.routeName);
    return;
  }

  void navigateToPrivacyPolicy() {
    _navigationService.pushNamed(PrivacyScreen.routeName);
    return;
  }

  void navigateToAbout() {
    _navigationService.pushNamed(AboutScreen.routeName);
    return;
  }

  List<Map<String, String>> items = [
    {
      'name': 'Profile',
      'icon': Assets.profileIcons.profile,
      'divider': 'true',
      'trailing': 'true',
    },

    {
      'name': 'Refer a Friend',
      'icon': Assets.profileIcons.referal,
      'divider': 'true',
      'trailing': 'true',
    },
    {
      'name': 'Library',
      'icon': Assets.profileIcons.library,
      'divider': 'true',
      'trailing': 'true',
    },
    {
      'name': 'Analytics',
      'icon': Assets.profileIcons.anylitices,
      'divider': 'true',
      'trailing': 'true',
    },
    {
      'name': 'Subscription',
      'icon': Assets.profileIcons.subscription,
      'divider': 'true',
      'trailing': 'true',
    },
    {
      'name': 'Language',
      'icon': Assets.profileIcons.language,
      'divider': 'true',
      'trailing': 'true',
    },
    {
      'name': 'Apple Health',
      'icon': Assets.profileIcons.appleHelth,
      'divider': 'true',
      'trailing': 'true',
      'hasButton': 'true',
    },
    {
      'name': 'App Settings',
      'icon': Assets.profileIcons.setting,
      'divider': 'true',
      'trailing': 'true',
    },
    {
      'name': 'Help Center',
      'icon': Assets.profileIcons.helpCenter,
      'divider': 'false',
      'trailing': 'false',
    },
    {
      'name': 'About',
      'icon': Assets.profileIcons.about,
      'divider': 'false',
      'trailing': 'false',
    },
    {
      'name': 'Privacy Policy',
      'icon': Assets.profileIcons.privacyPolicy,
      'divider': 'false',
      'trailing': 'false',
    },
    {
      'name': 'Terms of Service',
      'icon': Assets.profileIcons.termofservice,
      'divider': 'false',
      'trailing': 'false',
    },
    {
      'name': 'Log Out',
      'icon': Assets.profileIcons.logout,
      'divider': 'false',
      'trailing': 'false',
    },
  ];
}
