import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/common/data/discover_data.dart';
import 'package:mindfulminis/common/models/discover_section.dart';

class CollectionDiscoverProvider with ChangeNotifier {
  final DiscoverData discoverData;
  final String collectionSlug;
  final String? profileId;

  bool _isLoading = false;
  List<DiscoverSection> _sections = [];
  Set<String> _viewedContentIds = {};
  String? _error;

  CollectionDiscoverProvider({
    required this.discoverData,
    required this.collectionSlug,
    this.profileId,
  });

  bool get isLoading => _isLoading;
  List<DiscoverSection> get sections => _sections;
  Set<String> get viewedContentIds => _viewedContentIds;
  String? get error => _error;

  bool isViewed(String contentId) => _viewedContentIds.contains(contentId);

  bool isSeriesFullyViewed(List<String> contentIds) {
    if (contentIds.isEmpty) return false;
    return contentIds.every((id) => _viewedContentIds.contains(id));
  }

  Future<void> fetchDiscoverContent() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        discoverData.getDiscoverContent(collectionSlug),
        if (profileId != null && profileId!.isNotEmpty)
          discoverData.getViewedContentIds(
            collection: collectionSlug,
            profileId: profileId!,
          )
        else
          Future.value(<String>[]),
      ]);

      _sections = results[0] as List<DiscoverSection>;
      final viewedIds = results[1] as List<String>;
      _viewedContentIds = viewedIds.toSet();
    } catch (e) {
      _error = e.toString();
      log('CollectionDiscoverProvider error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markViewed(String contentId) async {
    if (profileId == null || profileId!.isEmpty) return;

    _viewedContentIds.add(contentId);
    notifyListeners();

    try {
      await discoverData.markContentViewed(
        profileId: profileId!,
        contentId: contentId,
        collection: collectionSlug,
      );
    } catch (e) {
      _viewedContentIds.remove(contentId);
      notifyListeners();
      log('Error marking content viewed, rolled back: $e');
    }
  }
}
