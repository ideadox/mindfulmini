import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/features/routine/models/activity_detail_model.dart';

import '../../../core/injection/injection.dart';
import '../routine_data/routine_data.dart';

class ActivitiesProvider with ChangeNotifier {
  final _routineData = sl<RoutineData>();

  bool loading = false;
  String? error;
  List<ActivityDetailModel> activities = [];

  /// Gratitude journal data returned alongside activities
  Map<String, dynamic>? gratitude;

  /// Affirmation content returned alongside activities
  Map<String, dynamic>? affirmation;

  /// GET /activities/activity?routineId=X&date=Y
  /// Fetches all activities with their CMS content for a given routine+date
  Future<void> getActivities(String routineId, String date) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      log('Fetching activities for routineId: $routineId, date: $date');
      final response = await _routineData.getActivities(routineId, date);
      activities = response.activities;
      gratitude = response.gratitude;
      affirmation = response.affirmation;

      log('Fetched ${activities.length} activities');
    } catch (e) {
      log('Error fetching activities: $e');
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Fetch and assign CMS content for a specific goal on a date.
  /// This triggers the lazy content assignment on the backend.
  Future<Map<String, dynamic>?> getActivityContent({
    required String profileId,
    required String goal,
    required String date,
  }) async {
    try {
      final data = await _routineData.getActivityContent(
        profileId: profileId,
        goal: goal,
        date: date,
      );
      // Update the local activity with the returned data
      if (data['activity'] != null) {
        final updatedActivity = ActivityDetailModel.fromJson(
          data['activity'] as Map<String, dynamic>,
        );
        final content =
            data['content'] != null
                ? ContentDetail.fromJson(
                  data['content'] as Map<String, dynamic>,
                )
                : null;
        final index = activities.indexWhere((a) => a.id == updatedActivity.id);
        if (index != -1) {
          activities[index] = activities[index].copyWith(
            contentId: updatedActivity.contentId,
            content: content,
          );
          notifyListeners();
        }
      }
      return data;
    } catch (e) {
      log('Error fetching activity content: $e');
      error = e.toString();
      notifyListeners();
      return null;
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

  /// PATCH /activities/progress — Update activity progress
  Future<void> updateActivityProgress(String activityId, int progress) async {
    try {
      await _routineData.updateActivityProgress(activityId, progress);

      // Update local activity
      final index = activities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        final hasFinished =
            activities[index].hasFinished || progress >= 100;
        final hasStarted =
            activities[index].hasStarted || progress > 0;
        final status =
            hasFinished
                ? 'completed'
                : progress > 0
                    ? 'in-progress'
                    : 'not-started';

        activities[index] = activities[index].copyWith(
          progressStatus: progress,
          status: status,
          hasFinished: hasFinished,
          hasStarted: hasStarted,
        );
        notifyListeners();
      }
    } catch (e) {
      log('Error updating activity progress: $e');
      error = e.toString();
      notifyListeners();
    }
  }

  /// PATCH /activities/reaction — Set like/dislike on an activity
  Future<void> setActivityReaction(
    String activityId,
    String reaction,
  ) async {
    try {
      await _routineData.setActivityReaction(activityId, reaction);

      final index = activities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        activities[index] = activities[index].copyWith(
          hasLiked: reaction == 'like',
          hasDisliked: reaction == 'dislike',
        );
        notifyListeners();
      }
    } catch (e) {
      log('Error setting activity reaction: $e');
      error = e.toString();
      notifyListeners();
    }
  }

  void clearActivities() {
    activities = [];
    gratitude = null;
    affirmation = null;
    error = null;
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
