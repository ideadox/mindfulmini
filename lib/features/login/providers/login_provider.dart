import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/services/exceptions.dart';

import '../../../injection/injection.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      navigateToKid();
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
