import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/common/data/discover_data.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/library/models/favorite_item.dart';
import 'package:mindfulminis/features/library/models/recent_viewed_item.dart';

class LibraryProvider with ChangeNotifier {
  final DiscoverData _discoverData = sl<DiscoverData>();

  // Favorite state
  final Set<String> _favoritedContentIds = {};
  List<FavoriteItem> _favorites = [];
  bool _favoritesLoading = false;
  String? _favoritesError;

  // Recently viewed state
  List<RecentViewedItem> _recentlyViewed = [];
  bool _recentLoading = false;
  String? _recentError;

  // Getters
  List<FavoriteItem> get favorites => _favorites;
  bool get favoritesLoading => _favoritesLoading;
  String? get favoritesError => _favoritesError;

  List<RecentViewedItem> get recentlyViewed => _recentlyViewed;
  bool get recentLoading => _recentLoading;
  String? get recentError => _recentError;

  bool isFavorited(String contentId) => _favoritedContentIds.contains(contentId);

  /// Group favorites by collection for the UI
  Map<String, List<FavoriteItem>> get favoritesByCollection {
    final map = <String, List<FavoriteItem>>{};
    for (final fav in _favorites) {
      map.putIfAbsent(fav.collection, () => []).add(fav);
    }
    return map;
  }

  // ── Favorites ──────────────────────────────────────────────────────

  Future<void> loadFavorites(String profileId) async {
    if (_favoritesLoading) return;
    _favoritesLoading = true;
    _favoritesError = null;
    notifyListeners();

    try {
      final result = await _discoverData.getFavorites(profileId: profileId);
      final rawList = result['favorites'] as List? ?? [];
      _favorites = rawList
          .map((e) => FavoriteItem.fromJson(e as Map<String, dynamic>))
          .toList();
      _favoritedContentIds
        ..clear()
        ..addAll(_favorites.map((f) => f.contentId));
    } catch (e) {
      _favoritesError = e.toString();
      log('Error loading favorites: $e');
    } finally {
      _favoritesLoading = false;
      notifyListeners();
    }
  }

  /// Check favorite status for a single content item (used on player open).
  Future<void> checkFavoriteStatus({
    required String profileId,
    required String contentId,
  }) async {
    try {
      final favorited = await _discoverData.getFavoriteStatus(
        profileId: profileId,
        contentId: contentId,
      );
      if (favorited) {
        _favoritedContentIds.add(contentId);
      } else {
        _favoritedContentIds.remove(contentId);
      }
      notifyListeners();
    } catch (e) {
      log('Error checking favorite status: $e');
    }
  }

  /// Toggle favorite with optimistic update.
  Future<void> toggleFavorite({
    required String profileId,
    required String contentId,
    required String collection,
  }) async {
    final wasFavorited = _favoritedContentIds.contains(contentId);

    // Optimistic update
    if (wasFavorited) {
      _favoritedContentIds.remove(contentId);
      _favorites.removeWhere((f) => f.contentId == contentId);
    } else {
      _favoritedContentIds.add(contentId);
    }
    notifyListeners();

    try {
      final nowFavorited = await _discoverData.toggleFavorite(
        profileId: profileId,
        contentId: contentId,
        collection: collection,
      );

      // Sync with server truth
      if (nowFavorited) {
        _favoritedContentIds.add(contentId);
      } else {
        _favoritedContentIds.remove(contentId);
        _favorites.removeWhere((f) => f.contentId == contentId);
      }
    } catch (e) {
      // Rollback on failure
      if (wasFavorited) {
        _favoritedContentIds.add(contentId);
      } else {
        _favoritedContentIds.remove(contentId);
      }
      log('Error toggling favorite: $e');
    }
    notifyListeners();
  }

  // ── Recently Viewed ────────────────────────────────────────────────

  Future<void> loadRecentlyViewed(String profileId) async {
    if (_recentLoading) return;
    _recentLoading = true;
    _recentError = null;
    notifyListeners();

    try {
      final rawList = await _discoverData.getRecentlyViewed(
        profileId: profileId,
      );
      _recentlyViewed = rawList
          .map((e) => RecentViewedItem.fromJson(e))
          .toList();
    } catch (e) {
      _recentError = e.toString();
      log('Error loading recently viewed: $e');
    } finally {
      _recentLoading = false;
      notifyListeners();
    }
  }

  /// Clear all cached data (e.g. on logout).
  void clear() {
    _favoritedContentIds.clear();
    _favorites = [];
    _recentlyViewed = [];
    _favoritesError = null;
    _recentError = null;
    notifyListeners();
  }
}
