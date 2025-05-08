import 'package:flutter/material.dart';

class TabViewProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onChangeIndex(index) {
    _currentIndex = index;
    notifyListeners();
  }
}
