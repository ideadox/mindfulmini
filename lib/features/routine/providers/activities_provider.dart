import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/features/routine/models/activity_detail_model.dart';

import '../../../injection/injection.dart';
import '../routine_data/routine_data.dart';

class ActivitiesProvider with ChangeNotifier {
  final _routineData = sl<RoutineData>();

  bool loading = false;
  String? error;
  List<ActivityDetailModel> activities = [];

  Future<void> getActivities(String routineId, String date) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      log('Fetching activities for routineId: $routineId, date: $date');
      activities = await _routineData.getActivities(routineId, date);

      log('Fetched ${activities.length} activities');
    } catch (e) {
      log('Error fetching activities: $e');
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  ActivityDetailModel? getActivityByGoal(String goal) {
    try {
      return activities.firstWhere(
        (activity) => activity.goal.toLowerCase() == goal.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  ActivityDetailModel? getActivityById(String activityId) {
    try {
      return activities.firstWhere((activity) => activity.id == activityId);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateActivityProgress(String activityId, int progress) async {
    try {
      await _routineData.updateRoutineActivityPercent(activityId, progress);

      // Update local activity
      final index = activities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        activities[index] = activities[index].copyWith(
          progressStatus: progress,
        );
        notifyListeners();
      }
    } catch (e) {
      log('Error updating activity progress: $e');
      error = e.toString();
      notifyListeners();
    }
  }

  void clearActivities() {
    activities = [];
    error = null;
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
