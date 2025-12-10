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
      await httpService.post(
        ApiConstants.addGratitudeJournalUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GratiudeJournalModel>> getGratitudeJournals(
    String profileId,
    String year,
    String month,
  ) async {
    try {
      final res = await httpService.get(
        '${ApiConstants.getMonthlyGratitudeUrl}?profileId=$profileId&year=$year&month=$month',
        headers: {'Content-Type': 'application/json'},
      );
      log(res.toString());

      List<GratiudeJournalModel> gratitudeJournals = [];
      for (var data in res['data']) {
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
