import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/services/http_service.dart';

class MeditationData {
  final HttpService httpService;

  MeditationData({required this.httpService});

  Future<List<YogaContentModel>> getMeditationSessions({
    int limitRaw = 20,
    int pageRaw = 1,
    String sortRaw = 'createdAt',
  }) async {
    try {
      final url =
          '${ApiConstants.getMeditationUrl}?limitRaw=$limitRaw&pageRaw=$pageRaw&sortRaw=$sortRaw';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        List<YogaContentModel> meditationSessions =
            (response['data'] as List)
                .map(
                  (meditation) => YogaContentModel.fromJson(
                    meditation as Map<String, dynamic>,
                  ),
                )
                .toList();
        return meditationSessions;
      }
      return [];
    } catch (e) {
      print('Error fetching meditation sessions: $e');
      rethrow;
    }
  }
}
