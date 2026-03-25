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
    int? completionPercent,
    int? totalListenTimeMs,
  }) async {
    try {
      final url = '${ApiConstants.cmsUrl}/viewed';
      final body = <String, dynamic>{
        'profileId': profileId,
        'contentId': contentId,
        'collection': collection,
      };
      if (completionPercent != null) {
        body['completionPercent'] = completionPercent;
      }
      if (totalListenTimeMs != null) {
        body['totalListenTimeMs'] = totalListenTimeMs;
      }
      await httpService.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
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

  // ── Favorites ──────────────────────────────────────────────────────

  /// Toggle favorite for a content item. Returns true if now favorited, false if removed.
  Future<bool> toggleFavorite({
    required String profileId,
    required String contentId,
    required String collection,
  }) async {
    final url = '${ApiConstants.cmsUrl}/favorite';
    final response = await httpService.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'profileId': profileId,
        'contentId': contentId,
        'collection': collection,
      }),
    );

    if (response['status'] == 200 && response['data'] != null) {
      return response['data']['favorited'] == true;
    }
    throw Exception('Failed to toggle favorite');
  }

  /// Check if a specific content item is favorited by the user.
  Future<bool> getFavoriteStatus({
    required String profileId,
    required String contentId,
  }) async {
    try {
      final url =
          '${ApiConstants.cmsUrl}/favorite/status?profileId=$profileId&contentId=$contentId';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        return response['data']['favorited'] == true;
      }
      return false;
    } catch (e) {
      log('Error checking favorite status: $e');
      return false;
    }
  }

  /// Fetch paginated favorites with full CMS content details.
  Future<Map<String, dynamic>> getFavorites({
    required String profileId,
    int limit = 50,
    int page = 1,
  }) async {
    try {
      final url =
          '${ApiConstants.cmsUrl}/favorites?profileId=$profileId&limit=$limit&page=$page';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }
      return {'favorites': [], 'total': 0};
    } catch (e) {
      log('Error fetching favorites: $e');
      rethrow;
    }
  }

  // ── Recently Viewed ────────────────────────────────────────────────

  /// Fetch recently viewed items across all collections with full CMS content.
  Future<List<Map<String, dynamic>>> getRecentlyViewed({
    required String profileId,
    int limit = 30,
  }) async {
    try {
      final url =
          '${ApiConstants.cmsUrl}/recently-viewed?profileId=$profileId&limit=$limit';
      final response = await httpService.get(url);

      if (response['status'] == 200 && response['data'] != null) {
        return (response['data'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      log('Error fetching recently viewed: $e');
      rethrow;
    }
  }
}
