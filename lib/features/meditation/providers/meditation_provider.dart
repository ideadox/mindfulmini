import 'package:flutter/material.dart';

class MeditationProvider with ChangeNotifier {
  // int currentIndex = 0;
  String currentTab = 'Morning';
  void changeIndex(String val) {
    // if (val == tabs[0]) {
    //   currentIndex = 0;
    // }
    // if (val == tabs[1]) {
    //   currentIndex = 1;
    // }
    // if (val == tabs[2]) {
    //   currentIndex = 2;
    // }

    currentTab = val;

    notifyListeners();
  }

  List<String> tabs = ['Morning', 'Afternoon', 'Evening'];
}
