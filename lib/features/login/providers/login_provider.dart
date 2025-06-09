import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';

import '../../../injection/injection.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isVisible = false;
  bool isLoading = false;

  void toogleVisiblity() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future<void> login() async {
    navigateToKid();
    return;
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
      throw e.message ?? '';
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void navigateToKid() {
    sl<GoRouter>().goNamed(KidName.routeName);
    return;
  }
}
