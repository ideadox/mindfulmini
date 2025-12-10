import 'dart:developer';

import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/services/http_service.dart';

class CmsData {
  final HttpService _httpService;

  CmsData({required HttpService httpService}) : _httpService = httpService;

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

  Future<CmsModel> getCMSById(String collection, String id) async {
    try {
      Uri url = Uri.parse('${ApiConstants.cmsByIdUrl}/$collection/$id');
      log(url.toString());
      final res = await _httpService.get(url.toString());
      return CmsModel.fromJson(res['data']);
    } catch (e) {
      rethrow;
    }
  }
}
