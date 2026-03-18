import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/features/routine/models/activity_model.dart';

import '../../../core/injection/injection.dart';
import '../routine_data/routine_data.dart';

class RoutineActivityProvider with ChangeNotifier {
  final _routineData = sl<RoutineData>();

  bool loading = false;
  bool innerLoading = false;

  RoutineActivityProvider(String id, String date, {DateTime? initialDate}) {
    if (initialDate != null) selectedDate = initialDate;
    getRoutineActivity(id, date);
  }

  GoalsSummary? activityModel;
  DateTime selectedDate = DateTime.now();

  void selectDate(DateTime date) {
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

      log('Fetching routine activity for id: $id, date: $date');
      activityModel = await _routineData.getRoutineActivity(id, date);

      if (activityModel != null) {
        const lastGoals = {'affirmation', 'gratitude journal'};
        final sorted = [
          ...activityModel!.goals.where(
            (g) => !lastGoals.contains(g.title.toLowerCase()),
          ),
          ...activityModel!.goals.where(
            (g) => lastGoals.contains(g.title.toLowerCase()),
          ),
        ];
        activityModel = activityModel!.copyWith(goals: sorted);
      }
    } catch (e) {
      log('Error fetching routine activity: $e');
      // Don't rethrow — show empty state instead of crashing
      activityModel = null;
    } finally {
      loading = false;
      innerLoading = false;
      notifyListeners();
    }
  }

  bool updating = false;

  /// Updates progress for a specific activity via PATCH
  Future<void> updateActivityContentProgress(
    String activityId,
    int progress,
  ) async {
    try {
      updating = true;
      notifyListeners();
      await _routineData.updateActivityProgress(activityId, progress);
    } catch (e) {
      log('Error updating activity progress: $e');
      rethrow;
    } finally {
      updating = false;
      notifyListeners();
    }
  }
}
