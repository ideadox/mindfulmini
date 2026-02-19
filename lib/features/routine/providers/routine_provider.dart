import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';

import '../../../core/injection/injection.dart';
import '../models/routine_model.dart';
import '../routine_data/routine_data.dart';

class RoutineProvider with ChangeNotifier {
  final _routineData = sl<RoutineData>();
  final String profileId;

  RoutineProvider(this.profileId) {
    getRoutines();
  }

  bool loading = false;
  String? error;
  List<RoutineModel> routines = [];

  /// Today's average activity-completion progress per routine (0–100).
  Map<String, int> routineProgress = {};

  Future<void> getRoutines({bool notify = true}) async {
    try {
      loading = true;
      error = null;
      if (notify) {
        notifyListeners();
      }
      routines = await _routineData.getRoutines(profileId);

      // Fetch today's activity-based progress for each routine in parallel
      await _fetchTodayProgress();
    } catch (e) {
      log('Error fetching routines: $e');
      error = e.toString();
      SmartDialog.showToast(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Refresh only the progress map (lightweight).
  Future<void> refreshProgress() async {
    try {
      await _fetchTodayProgress();
    } catch (e) {
      log('[RoutineProvider] refreshProgress error: $e');
    } finally {
      notifyListeners();
    }
  }

  bool _fetchingProgress = false;

  /// Pick the correct date for a routine: if the routine hasn't started yet
  /// (startDate is in the future), use its startDate; otherwise use today.
  /// This matches the logic in RoutineDetailScreen.
  String _effectiveDateFor(RoutineModel routine) {
    final now = DateTime.now();
    final date = routine.startDate.isAfter(now) ? routine.startDate : now;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _fetchTodayProgress() async {
    if (_fetchingProgress) return; // prevent overlapping fetches
    _fetchingProgress = true;
    try {
      for (final routine in routines) {
        try {
          final date = _effectiveDateFor(routine);
          final goals = await _routineData.getRoutineActivity(
            routine.id,
            date,
          );
          routineProgress[routine.id] = goals.averageProgress.round();
        } catch (e) {
          log('[RoutineProvider] ERROR for ${routine.id}: $e');
          routineProgress[routine.id] = 0;
        }
      }
    } finally {
      _fetchingProgress = false;
    }
  }
}
