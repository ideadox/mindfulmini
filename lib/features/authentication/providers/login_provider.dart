import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/services/exceptions.dart';

import '../../../injection/injection.dart';
import '../../../services/storage/token_storage.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  final _tokenStorage = sl<TokenStorage>();

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
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      if (userCredential.user != null) {
        try {
          final token = await userCredential.user!.getIdToken(true);
          log('Login Token: $token');

          if (token != null && token.isNotEmpty) {
            await _tokenStorage.saveAccessToken(token);
            navigateToHome();
          } else {
            error = 'Failed to get authentication token. Please try again.';
            log('Token is null or empty');
          }
        } catch (e) {
          error = 'Failed to complete login. Please try again.';
          log('Error getting token: $e');
        }
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

  void navigateToHome() {
    sl<GoRouter>().goNamed(TabView.routeName);
    return;
  }
}
