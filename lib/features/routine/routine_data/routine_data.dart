import 'dart:convert';
import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/features/routine/models/activity_model.dart';

import 'package:mindfulminis/services/http_service.dart';

import '../models/routine_model.dart';

class RoutineData {
  final HttpService httpService;

  RoutineData({required this.httpService});

  Future<void> createRoutine(var map) async {
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
          continue;
        }
      }
      return routines;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<void> updateRoutineActivityPercent(String id, int progress) async {
    try {
      await httpService.post(
        ApiConstants.updateRoutineActivityPercentUrl + id,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"progressStatus": progress}),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createJournal(var map) async {
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
