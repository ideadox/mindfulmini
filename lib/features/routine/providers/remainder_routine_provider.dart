import 'package:flutter/material.dart';

class RemainderRoutineProvider with ChangeNotifier {
  bool remainder = false;
  TimeOfDay? selectedTime;

  void updateTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void toogleRemaider() {
    remainder = !remainder;
    notifyListeners();
  }

  final List<String> weekDay = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  final List<String> selectedDay = [];

  void updateSelection(val) {
    if (selectedDay.contains(val)) {
      selectedDay.remove(val);
    } else {
      selectedDay.add(val);
    }

    notifyListeners();
  }
}
