import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isVisible = false;

  void toogleVisiblity() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
