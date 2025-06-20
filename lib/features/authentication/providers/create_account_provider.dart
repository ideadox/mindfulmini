import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/authentication/auth_data/auth_data.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:mindfulminis/services/exceptions.dart';

import '../../../services/shared_prefs.dart';

class CreateAccountProvoider with ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthData _authData = sl<AuthData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();

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
    resetError();
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      loading = true;
      notifyListeners();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String name = nameController.text.trim();
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await user.updateDisplayName(name);
          var map = {
            "email": email,
            "firstName": name,
            "firebaseUid": user.uid,
          };

          final userId = await _authData.createUser(map);
          await _sharedPrefs.setUserId(userId);

          sl<GoRouter>().goNamed(KidName.routeName);
        } else {
          error = 'Something went wrong';
        }
      } else {
        error = 'Something went wrong';
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      error = ResolveError.resolve(e.code);
    } catch (e) {
      error = 'Something went wrong';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
