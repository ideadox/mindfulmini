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
      final res = await httpService.post(
        ApiConstants.createRoutineUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );
      log(res.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RoutineModel>> getRoutines(String userid) async {
    try {
      final res = await httpService.get(ApiConstants.getRoutinesUrl + userid);
      log(res.toString());
      List<RoutineModel> routines = [];
      for (var routine in res['data']['routines']) {
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

  Future<ActivityModel> getRoutineActivity(String id, String date) async {
    try {
      final res = await httpService.post(
        ApiConstants.getRoutineActivityUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"routineId": id, "date": date}),
      );

      return ActivityModel.fromJson(res['data']['activity']);
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
