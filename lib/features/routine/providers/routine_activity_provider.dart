import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/routine/models/activity_model.dart';

import '../../../injection/injection.dart';
import '../../../services/shared_prefs.dart';
import '../routine_data/routine_data.dart';

class RoutineActivityProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final _routineData = sl<RoutineData>();
  final _sharedPrefs = sl<SharedPrefs>();
  bool loading = false;
  bool innerLoading = false;

  RoutineActivityProvider(String id, String date) {
    getRoutineActivity(id, date);
  }
  // ValueChanged<DateTime> onDateSelected;

  ActivityModel? activityModel;
  DateTime selectedDate = DateTime.now();

  void selectDate(date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<void> getRoutineActivity(
    String id,
    String date, {
    bool innerNotify = false,
  }) async {
    try {
      if (innerNotify) {
        innerLoading = true;
      } else {
        loading = true;
      }
      notifyListeners();
      log(date);

      activityModel = await _routineData.getRoutineActivity(id, date);
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      innerLoading = false;
      notifyListeners();
    }
  }

  bool updating = false;

  Future<void> updateActivityContentProgress(String id, int progress) async {
    try {
      updating = true;
      notifyListeners();
      await _routineData.updateRoutineActivityPercent(id, progress);
    } catch (e) {
      rethrow;
    } finally {
      updating = false;
      notifyListeners();
    }
  }
}
