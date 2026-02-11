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
          'page': page.toString(),
          'limit': limit.toString(),
          'sort': sort,
        },
      );
      // Commented out verbose logging
      // log('Fetching CMS content from: ${url.toString()}');
      List<CmsModel> cms = [];
      final res = await _httpService.get(url.toString());
      // Commented out verbose logging
      // log('Response keys: ${res.keys}');
      // log('Response data type: ${res['data'].runtimeType}');
      
      // Check if response has data field
      if (res['data'] != null && res['data'] is List) {
        // Commented out verbose logging
        // log('Found ${(res['data'] as List).length} items in data array');
        for (int i = 0; i < (res['data'] as List).length; i++) {
          var c = (res['data'] as List)[i];
          try {
            // Commented out verbose logging
            // if (i == 0) {
            //   log('First item structure - keys: ${(c as Map).keys}');
            //   log('First item - title: ${c['title']}, seriesName: ${c['seriesName']}, tags: ${c['tags']}');
            // }
            cms.add(CmsModel.fromJson(c));
          } catch (e) {
            log('Error parsing CMS item at index $i: $e');
            // Commented out verbose logging
            // if (c is Map) {
            //   log('Item keys: ${c.keys}');
            //   log('Item title: ${c['title']}');
            //   log('Item seriesName: ${c['seriesName']}');
            //   log('Item tags: ${c['tags']}');
            //   log('Item contentDescription: ${c['contentDescription']}');
            // }
            continue;
          }
        }
      } else {
        log('No data field found or data is not a list');
        // If no data field, try direct list
        if (res is List) {
          // Commented out verbose logging
          // log('Response is a direct list with ${res.length} items');
          for (var c in res) {
            try {
              cms.add(CmsModel.fromJson(c));
            } catch (e) {
              log('Error parsing CMS item: $e');
              continue;
            }
          }
        }
      }
      // Commented out verbose logging
      // log('Successfully parsed ${cms.length} CMS items');
      return cms;
    } catch (e) {
      log('Error in getCMSContentByCollection for $collection: $e');
      rethrow;
    }
  }
}
