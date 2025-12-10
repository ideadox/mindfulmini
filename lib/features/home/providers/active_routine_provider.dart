import 'package:flutter/material.dart';

import '../../../injection/injection.dart';
import '../../routine/models/routine_model.dart';
import '../../routine/routine_data/routine_data.dart';

class ActiveRoutineProvider with ChangeNotifier {
  final _routineData = sl<RoutineData>();

  bool loading = false;
  List<RoutineModel> routines = [];
  Future<void> getRoutines(String profileId, {bool notify = true}) async {
    try {
      loading = true;
      if (notify) {
        notifyListeners();
      }
      routines = await _routineData.getRoutines(profileId);
    } catch (_) {
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
