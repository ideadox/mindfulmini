import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/services/exceptions.dart';

import '../../../injection/injection.dart';
import '../../../services/shared_prefs.dart';
import '../../../services/storage/token_storage.dart';
import '../auth_data/auth_data.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  final _authData = sl<AuthData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();
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
        final token = await _authData.loginUser({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        });

        await _tokenStorage.saveAccessToken(token);
        navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      error = ResolveError.resolve(e.code);
    } catch (e) {
      rethrow;
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
