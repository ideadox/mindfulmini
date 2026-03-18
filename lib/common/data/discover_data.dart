import 'dart:convert';
import 'dart:developer';

import 'package:mindfulminis/common/models/discover_section.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/services/http_service.dart';

class DiscoverData {
  final HttpService httpService;

  DiscoverData({required this.httpService});

  Future<List<DiscoverSection>> getDiscoverContent(String collection) async {
    try {
      final url = '${ApiConstants.cmsUrl}/$collection/discover';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        final sections = data['sections'] as List? ?? [];
        return sections
            .map((s) =>
                DiscoverSection.fromJson(s as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      log('Error fetching discover content: $e');
      rethrow;
    }
  }

  Future<void> markContentViewed({
    required String profileId,
    required String contentId,
    required String collection,
  }) async {
    try {
      final url = '${ApiConstants.cmsUrl}/viewed';
      await httpService.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'profileId': profileId,
          'contentId': contentId,
          'collection': collection,
        }),
      );
    } catch (e) {
      log('Error marking content viewed: $e');
    }
  }

  Future<List<String>> getViewedContentIds({
    required String collection,
    required String profileId,
  }) async {
    try {
      final url =
          '${ApiConstants.cmsUrl}/$collection/viewed?profileId=$profileId';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        return (response['data'] as List)
            .map((e) => e.toString())
            .toList();
      }
      return [];
    } catch (e) {
      log('Error fetching viewed content: $e');
      rethrow;
    }
  }
}
