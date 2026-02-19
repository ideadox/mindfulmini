import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/core/services/http_service.dart';

class BreathingData {
  final HttpService httpService;

  BreathingData({required this.httpService});

  Future<List<YogaContentModel>> getBreathingSessions({
    int limitRaw = 20,
    int pageRaw = 1,
    String sortRaw = 'createdAt',
  }) async {
    try {
      final url =
          '${ApiConstants.getBreathingUrl}?limitRaw=$limitRaw&pageRaw=$pageRaw&sortRaw=$sortRaw';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        List<YogaContentModel> breathingSessions =
            (response['data'] as List)
                .map(
                  (breathing) => YogaContentModel.fromJson(
                    breathing as Map<String, dynamic>,
                  ),
                )
                .toList();
        return breathingSessions;
      }
      return [];
    } catch (e) {
      log('Error fetching breathing sessions: $e');
      rethrow;
    }
  }
}
