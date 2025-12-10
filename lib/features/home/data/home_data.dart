import 'dart:developer';

import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/services/http_service.dart';

class HomeData {
  final HttpService _httpService;

  HomeData({required HttpService httpService}) : _httpService = httpService;

  Future<List<CmsModel>> getCMSContentByCollection(
    String collection, {
    int page = 1,
    int limit = 10,
    String sort = 'createdAt',
  }) async {
    try {
      Uri url = Uri.parse('${ApiConstants.cmsUrl}/$collection').replace(
        queryParameters: {
          'pageRaw': page.toString(),
          'limitRaw': limit.toString(),
          'sortRaw': sort,
        },
      );
      List<CmsModel> cms = [];
      final res = await _httpService.get(url.toString());
      for (var c in res['data']) {
        try {
          cms.add(CmsModel.fromJson(c));
        } catch (e) {
          continue;
        }
      }
      return cms;
    } catch (e) {
      rethrow;
    }
  }
}
