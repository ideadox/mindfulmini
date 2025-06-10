import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/injection/injection.dart';

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

  Future<void> signUp() async {
    sl<GoRouter>().pushReplacementNamed(KidName.routeName);
    return;
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      loading = true;
      notifyListeners();
      // Create email/password credential
      final credential = EmailAuthProvider.credential(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;
      // Ensure user is signed in
      if (user != null) {
        // Link the credential
        await user.linkWithCredential(credential);
        await user.updateDisplayName(nameController.text.trim());
        print('Email/password linked successfully!');
      } else {
        print('No user is signed in.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        print('The provider is already linked to the user.');
      } else if (e.code == 'email-already-in-use') {
        print('The email is already linked to another account.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
