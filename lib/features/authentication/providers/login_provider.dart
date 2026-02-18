import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/features/profile/profile_data/profile_data.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/core/services/exceptions.dart';

import '../../../core/injection/injection.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  final _profileData = sl<ProfileData>();

  bool isVisible = false;
  bool isLoading = false;
  String? error;
  resetError() {
    error = null;
  }

  void toogleVisiblity() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future<void> login() async {
    resetError();
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      isLoading = true;
      notifyListeners();

      // Sign in with Firebase – the SDK persists the session and manages
      // token refresh automatically. No need to manually save tokens.
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      if (userCredential.user != null) {
        log('✅ Firebase login successful: ${userCredential.user!.uid}');
        await _navigateBasedOnProfile();
      } else {
        error = 'Login failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      log('Firebase auth error: ${e.toString()}');
      error = ResolveError.resolve(e.code);
    } catch (e) {
      error = 'An unexpected error occurred. Please try again.';
      log('Unexpected error during login: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Check if user has completed onboarding and navigate accordingly
  Future<void> _navigateBasedOnProfile() async {
    try {
      await _profileData.getUser();
      log('✅ Profile exists - navigating to home');
      sl<GoRouter>().goNamed(TabView.routeName);
    } on ProfileNotFoundException {
      // No profile exists - user needs to complete onboarding
      log('📝 No profile found - redirecting to onboarding');
      sl<GoRouter>().goNamed(KidName.routeName);
    } catch (e) {
      // Other error fetching profile - still try to navigate to onboarding
      // as it's safer than going to home without a profile
      log('⚠️ Error checking profile, redirecting to onboarding: $e');
      sl<GoRouter>().goNamed(KidName.routeName);
    }
  }

  void navigateToHome() {
    sl<GoRouter>().goNamed(TabView.routeName);
    return;
  }
}
