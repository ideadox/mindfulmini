import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/auth_service.dart';

import '../../library/screens/library_screen.dart';
import '../../onboarding/screens/onboard_screen.dart';
import '../../privacy/screens/privacy_screen.dart';
import '../../../core/services/exceptions.dart';
import '../../../core/services/shared_prefs.dart';
import '../models/user_profile.dart';
import '../profile_data/profile_data.dart';
import '../screens/edit_profile_screen.dart';

class ProfileProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final _profileData = sl<ProfileData>();
  final _sharedPrefs = sl<SharedPrefs>();
  final _authService = sl<AuthService>();

  User? get currentUser => _authService.currentUser;

  String? userId;
  UserProfile? userProfile;
  bool loading = false;
  bool updating = false;
  bool _isLoggingOut = false; // Flag to prevent multiple logout calls
  String? error;

  bool get isLoggingOut => _isLoggingOut;

  bool get hasProfile => userProfile != null;
  ProfileProvider() {
    // if (currentUser == null) {
    //   return;
    // }
    // userId = _sharedPrefs.getUserId();
    // getUser(notify: false);
  }

  Future<void> getUser({bool notify = true}) async {
    try {
      loading = true;
      error = null;
      if (notify) {
        notifyListeners();
      }

      userProfile = await _profileData.getUser();
      error = null;
    } on ProfileNotFoundException catch (e) {
      // Profile doesn't exist - this is critical data, log out the user
      log('❌ Profile not found - logging out user: ${e.message}');
      userProfile = null;
      error = null;
      // Log out and navigate to fresh state
      await _forceLogout();
    } on UnauthorisedException catch (e) {
      // If authentication fails persistently, user may not exist in backend
      // Clear auth state and set error
      error = e.message.isNotEmpty ? e.message : 'Authentication failed. Please log in again.';
      userProfile = null;
      log('❌ Profile fetch failed: ${e.message}');
      // Don't rethrow - let the UI handle the error state
    } catch (e) {
      error = e.toString();
      userProfile = null;
      log('❌ Profile fetch error: $e');
      // Don't rethrow - let the UI handle the error state
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      updating = true;
      error = null;
      notifyListeners();
      await _profileData.updateProfile(updatedProfile);
      userProfile = await _profileData.getUser();
      SmartDialog.showToast('Profile updated');
      _navigationService.pop();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      updating = false;
      notifyListeners();
    }
  }

  Future<void> logOutUser() async {
    // Prevent multiple simultaneous logout calls
    if (_isLoggingOut) {
      log('⚠️ Logout already in progress, skipping duplicate call');
      return;
    }
    await _forceLogout();
  }

  /// Internal method to force logout and navigate to fresh state.
  ///
  /// Signs out of Firebase (which is the single source of auth truth),
  /// clears local data, and navigates to the onboard screen.
  Future<void> _forceLogout() async {
    // Prevent multiple simultaneous logout calls
    if (_isLoggingOut) {
      return;
    }
    _isLoggingOut = true;
    notifyListeners();
    
    try {
      // Sign out via AuthService – the single source of auth truth.
      // HttpService will no longer be able to get tokens after this.
      await _authService.signOut();
      
      // Clear SharedPreferences (userId)
      await _sharedPrefs.clearUserId();
      userId = null;
      
      // Clear profile state
      userProfile = null;
      error = null;
      
      notifyListeners();
      
      // Navigate to onboard screen (fresh state)
      _navigationService.goNamed(OnboardScreen.routeName);
    } catch (e) {
      error = 'Failed to logout: ${e.toString()}';
      log('❌ Error during force logout: $e');
      // Even if logout fails, try to navigate to fresh state
      try {
        _navigationService.goNamed(OnboardScreen.routeName);
      } catch (navError) {
        log('❌ Error navigating to onboard: $navError');
      }
    } finally {
      _isLoggingOut = false;
      notifyListeners();
    }
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
