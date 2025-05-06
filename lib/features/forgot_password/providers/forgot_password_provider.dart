import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotpasswordProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  String? message;
  bool isLoading = false;
  void sendResetLink() async {
    try {
      if (emailController.text.isEmpty) {
        return;
      }
      isLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      message = 'Please check your email, and follow the instructions';
    } on FirebaseAuthException catch (e) {
      message = e.message ?? '';
    } catch (e) {
      message = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
