import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/injection/injection.dart';
import '../../routine/models/routine_model.dart';
import '../../routine/routine_data/routine_data.dart';

class ActiveRoutineProvider with ChangeNotifier {
  final _routineData = sl<RoutineData>();

  bool _disposed = false;
  bool loading = false;
  String? error;
  List<RoutineModel> routines = [];

  /// Today's average activity-completion progress per routine (0–100).
  Map<String, int> routineProgress = {};

  /// Prevents re-fetching routines when they're already loaded or in-flight.
  bool _routinesFetched = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> getRoutines(String profileId, {bool notify = true}) async {
    if (_routinesFetched || loading) return;
    try {
      loading = true;
      error = null;
      if (notify) _safeNotify();
      routines = await _routineData.getRoutines(profileId);
      _routinesFetched = true;
      await _fetchTodayProgress();
    } catch (e) {
      log('Error fetching active routines: $e');
      error = e.toString();
    } finally {
      loading = false;
      _safeNotify();
    }
  }

  /// Refresh only the progress map (lightweight — called when returning
  /// from RoutineDetailScreen so the cards update without refetching routines).
  Future<void> refreshProgress() async {
    try {
      await _fetchTodayProgress();
    } catch (e) {
      log('[ActiveRoutineProvider] refreshProgress error: $e');
    } finally {
      _safeNotify();
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
          log('[ActiveRoutineProvider] ERROR for ${routine.id}: $e');
          routineProgress[routine.id] = 0;
        }
      }
    } finally {
      _fetchingProgress = false;
    }
  }

  bool get hasRoutines => routines.isNotEmpty;
}
