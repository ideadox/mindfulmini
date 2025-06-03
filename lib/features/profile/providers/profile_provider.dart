import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/analytices/screens/analytic_screen.dart';
import 'package:mindfulminis/features/help_center/screens/help_center_screen.dart';
import 'package:mindfulminis/features/profile/screens/app_setting_screen.dart';
import 'package:mindfulminis/features/profile/screens/language_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../screens/edit_profile_screen.dart';

class ProfileProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();

  void navigateToEditProfile() {
    _navigationService.pushNamed(EditProfileScreen.routeName);
    return;
  }

  void navigateToAnalytices() {
    _navigationService.pushNamed(AnalyticScreen.routeName);
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

  List<Map<String, String>> items = [
    {
      'name': 'Profile',
      'icon': Assets.profileIcons.profile,
      'divider': 'true',
      'trailing': 'true',
    },

    {
      'name': 'Referral Friends Now',
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
      'name': 'App Setting',
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
      'name': 'Log out',
      'icon': Assets.profileIcons.logout,
      'divider': 'false',
      'trailing': 'false',
    },
  ];
}
