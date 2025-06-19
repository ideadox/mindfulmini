import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/services/exceptions.dart';

import '../../../injection/injection.dart';
import '../../../services/shared_prefs.dart';
import '../auth_data/auth_data.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  final _authData = sl<AuthData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();

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
        final userId = await _authData.createUser({
          "email": emailController.text.trim(),
          "firstName": userCredential.user?.displayName,
          "firebaseUid": userCredential.user?.uid,
        });

        await _sharedPrefs.setUserId(userId);
        log('saved shaed');

        navigateToKid();
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

  void navigateToKid() {
    sl<GoRouter>().goNamed(TabView.routeName);
    return;
  }
}
