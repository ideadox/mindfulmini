import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../services/shared_prefs.dart';
import '../models/routine_model.dart';
import '../routine_data/routine_data.dart';

class RoutineProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final _routineData = sl<RoutineData>();
  final _sharedPrefs = sl<SharedPrefs>();
  RoutineProvider() {
    getRoutines();
  }

  bool loading = false;
  List<RoutineModel> routines = [];
  Future<void> getRoutines() async {
    try {
      loading = true;
      notifyListeners();
      routines = await _routineData.getRoutines(_sharedPrefs.getUserId() ?? "");
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
