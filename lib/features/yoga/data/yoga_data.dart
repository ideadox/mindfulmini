import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/yoga/models/yoga_model.dart';
import 'package:mindfulminis/services/http_service.dart';

class YogaData {
  final HttpService httpService;

  YogaData({required this.httpService});

  Future<List<YogaModel>> getYogaPoses({
    int limitRaw = 20,
    int pageRaw = 1,
    String sortRaw = 'createdAt',
  }) async {
    try {
      final url =
          '${ApiConstants.getYogaUrl}?limitRaw=$limitRaw&pageRaw=$pageRaw&sortRaw=$sortRaw';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        List<YogaModel> yogaPoses =
            (response['data'] as List)
                .map((yoga) => YogaModel.fromJson(yoga as Map<String, dynamic>))
                .toList();
        return yogaPoses;
      }
      return [];
    } catch (e) {
      print('Error fetching yoga poses: $e');
      rethrow;
    }
  }

  Future<YogaContentModel> getYogaContentById(String id) async {
    try {
      final url = '${ApiConstants.cmsByIdUrl}/yoga/$id';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        return YogaContentModel.fromJson(
          response['data'] as Map<String, dynamic>,
        );
      }
      throw Exception('Failed to fetch yoga content');
    } catch (e) {
      log('Error fetching yoga content: $e');
      rethrow;
    }
  }
}
