import 'dart:convert';
import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/features/routine/models/activity_model.dart';
import 'package:mindfulminis/features/routine/models/activity_detail_model.dart';

import 'package:mindfulminis/core/services/http_service.dart';

import '../models/routine_model.dart';

/// Response model for getActivitiesByDate which includes activities,
/// gratitude journal, and affirmation content.
class ActivitiesByDateResponse {
  final List<ActivityDetailModel> activities;
  final Map<String, dynamic>? gratitude;
  final Map<String, dynamic>? affirmation;

  ActivitiesByDateResponse({
    required this.activities,
    this.gratitude,
    this.affirmation,
  });
}

class RoutineData {
  final HttpService httpService;

  RoutineData({required this.httpService});

  /// POST /routines — Create a new routine (auto-generates activities on the backend)
  Future<void> createRoutine(Map<String, dynamic> map) async {
    try {
      await httpService.post(
        ApiConstants.createRoutineUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /routines/:id/extend — Extend an existing routine by additional days
  Future<RoutineModel> extendRoutine(String routineId, int additionalDays) async {
    try {
      final res = await httpService.patch(
        '${ApiConstants.createRoutineUrl}/$routineId/extend',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'additionalDays': additionalDays}),
      );
      return RoutineModel.fromJson(res['data']);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /routines?profileId=X — Fetch all routines for a profile
  Future<List<RoutineModel>> getRoutines(String profileId) async {
    try {
      final res = await httpService.get(
        '${ApiConstants.getRoutinesUrl}?profileId=$profileId',
      );

      List<RoutineModel> routines = [];
      for (var routine in res['data']) {
        try {
          routines.add(RoutineModel.fromJson(routine));
        } catch (e) {
          log('Error parsing routine: $e');
          continue;
        }
      }
      return routines;
    } catch (e) {
      rethrow;
    }
  }

  /// GET /routines/goals?routineId=X&date=Y — Fetch goals progress summary for a date
  Future<GoalsSummary> getRoutineActivity(String id, String date) async {
    try {
      final res = await httpService.get(
        '${ApiConstants.getGoalsUrl}?routineId=$id&date=$date',
        headers: {'Content-Type': 'application/json'},
      );

      return GoalsSummary.fromJson(res['data']);
    } catch (e) {
      rethrow;
    }
  }

  /// GET /activities/activity?routineId=X&date=Y — Fetch activities with CMS content
  /// Returns enriched activities + gratitude + affirmation
  Future<ActivitiesByDateResponse> getActivities(
    String routineId,
    String date,
  ) async {
    try {
      final res = await httpService.get(
        '${ApiConstants.getActivitiesUrl}?date=$date&routineId=$routineId',
        headers: {'Content-Type': 'application/json'},
      );

      final data = res['data'];

      // Parse activities from the nested 'activities' key
      List<ActivityDetailModel> activities = [];
      final activitiesList = data['activities'] as List<dynamic>? ?? [];
      for (var activity in activitiesList) {
        try {
          activities.add(ActivityDetailModel.fromJson(activity));
        } catch (e) {
          log('Error parsing activity: $e');
          continue;
        }
      }

      return ActivitiesByDateResponse(
        activities: activities,
        gratitude: data['gratitude'] as Map<String, dynamic>?,
        affirmation: data['affirmation'] as Map<String, dynamic>?,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /activities/progress — Update activity progress by activityId
  Future<void> updateActivityProgress(String activityId, int progress) async {
    try {
      await httpService.patch(
        ApiConstants.updateActivityProgressUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'activityId': activityId,
          'progressStatus': progress,
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// GET /activities/content?profileId=X&goal=Y&date=Z
  /// Lazily assigns CMS content to an activity and returns both
  Future<Map<String, dynamic>> getActivityContent({
    required String profileId,
    required String goal,
    required String date,
  }) async {
    try {
      final res = await httpService.get(
        '${ApiConstants.getActivityContentUrl}?profileId=$profileId&goal=$goal&date=$date',
        headers: {'Content-Type': 'application/json'},
      );
      return res['data'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH /activities/reaction — Set like/dislike on an activity
  Future<void> setActivityReaction(String activityId, String reaction) async {
    try {
      await httpService.patch(
        ApiConstants.setActivityReactionUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'activityId': activityId,
          'reaction': reaction,
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// POST /activities/gratitude — Save a gratitude journal entry
  Future<void> createJournal(Map<String, dynamic> map) async {
    try {
      final res = await httpService.post(
        ApiConstants.addGratitudeJournalUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );
      log(res.toString());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
