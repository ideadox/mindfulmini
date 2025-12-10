import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../services/shared_prefs.dart';
import '../models/routine_model.dart';
import '../routine_data/routine_data.dart';

class RoutineProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final _routineData = sl<RoutineData>();
  final _sharedPrefs = sl<SharedPrefs>();
  String profileId;
  RoutineProvider(this.profileId) {
    getRoutines();
  }

  bool loading = false;
  List<RoutineModel> routines = [];
  Future<void> getRoutines({bool notify = true}) async {
    try {
      loading = true;
      if (notify) {
        notifyListeners();
      }
      routines = await _routineData.getRoutines(profileId);
    } catch (e) {
      SmartDialog.showToast(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
