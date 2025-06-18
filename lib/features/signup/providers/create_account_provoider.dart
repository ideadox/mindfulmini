import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:mindfulminis/services/exceptions.dart';

class CreateAccountProvoider with ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isVisible = false;

  void toogleVisiblity() {
    isVisible = !isVisible;
    notifyListeners();
  }

  bool loading = false;

  String? error;

  void resetError() {
    error = null;
  }

  Future<void> signUp() async {
    // sl<GoRouter>().pushReplacementNamed(KidName.routeName);
    // return;
    resetError();
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      loading = true;
      notifyListeners();

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateDisplayName(nameController.text.trim());
        sl<GoRouter>().goNamed(KidName.routeName);
      } else {
        error = 'Something went wrong';
      }
    } on FirebaseAuthException catch (e) {
      error = ResolveError.resolve(e.code);
    } catch (e) {
      error = 'Something went wrong';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
