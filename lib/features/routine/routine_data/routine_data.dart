import 'dart:convert';
import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';

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
}
