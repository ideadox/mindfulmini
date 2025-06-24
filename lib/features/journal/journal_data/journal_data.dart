import 'dart:convert';
import 'dart:developer';

import '../../../core/api_constants.dart';
import '../../../services/http_service.dart';
import '../models/gratiude_journal_model.dart';

class JournalData {
  final HttpService httpService;

  JournalData({required this.httpService});

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

  Future<List<GratiudeJournalModel>> getGratitudeJournals(var map) async {
    try {
      final res = await httpService.post(
        ApiConstants.getGratitudeJournalUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );
      log(res.toString());

      List<GratiudeJournalModel> gratitudeJournals = [];
      for (var data in res['data']['gratitudes']) {
        try {
          gratitudeJournals.add(
            GratiudeJournalModel.fromJson(data as Map<String, dynamic>),
          );
        } catch (e) {
          continue;
        }
      }

      return gratitudeJournals;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
