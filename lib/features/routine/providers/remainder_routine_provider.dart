import 'package:flutter/material.dart';

class RemainderRoutineProvider with ChangeNotifier {
  bool remainder = false;
  TimeOfDay? selectedTime = TimeOfDay(hour: 1, minute: 00);

  void updateTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void toogleRemaider() {
    remainder = !remainder;
    notifyListeners();
  }

  final List<String> weekDay = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
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
