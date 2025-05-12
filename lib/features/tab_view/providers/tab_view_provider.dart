import 'package:flutter/material.dart';
import 'package:mindfulminis/features/activity/screens/activity_screen.dart';
import 'package:mindfulminis/features/home/screens/home_screen.dart';
import 'package:mindfulminis/features/journal/screens/journal_screen.dart';
import 'package:mindfulminis/features/routine/screens/routine_screen.dart';

import '../../profile/screens/profile_screen.dart';

class TabViewProvider with ChangeNotifier {
  TabViewProvider() {
    _currentIndex = 0;
  }
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onChangeIndex(index) {
    _currentIndex = index;
    notifyListeners();
  }

  List<Widget> screens = [
    HomeScreen(),
    ActivityScreen(),
    JournalScreen(),
    RoutineScreen(),
    ProfileScreen(),
  ];
}
