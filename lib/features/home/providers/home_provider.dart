import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/features/home/data/home_data.dart';
import 'package:mindfulminis/injection/injection.dart';

class HomeProvider with ChangeNotifier {
  final _data = sl<HomeData>();

  // Data lists
  List<CmsModel> _stories = [];
  List<CmsModel> _breathing = [];
  List<CmsModel> _meditation = [];
  List<CmsModel> _yoga = [];

  // Getters
  List<CmsModel> get stories => _stories;
  List<CmsModel> get breathing => _breathing;
  List<CmsModel> get meditation => _meditation;
  List<CmsModel> get yoga => _yoga;

  // Loading states
  bool _isLoadingStories = false;
  bool _isLoadingBreathing = false;
  bool _isLoadingMeditation = false;
  bool _isLoadingYoga = false;

  bool get isLoadingStories => _isLoadingStories;
  bool get isLoadingBreathing => _isLoadingBreathing;
  bool get isLoadingMeditation => _isLoadingMeditation;
  bool get isLoadingYoga => _isLoadingYoga;
  
  // Overall loading state - true if any content is loading
  bool get isLoading => _isLoadingStories || _isLoadingBreathing || _isLoadingMeditation || _isLoadingYoga;

  HomeProvider() {
    // Load data when provider is created - don't await to avoid blocking
    loadAllContent();
  }

  Future<void> loadAllContent() async {
    // Load all content in parallel, but don't block on errors
    await Future.wait([
      loadStories(),
      loadBreathing(),
      loadMeditation(),
      loadYoga(),
    ], eagerError: false);
  }

  Future<void> loadStories() async {
    try {
      _isLoadingStories = true;
      notifyListeners();
      _stories = await _data.getCMSContentByCollection(
        'stories',
        page: 1,
        limit: 20,
        sort: 'createdAt',
      );
    } catch (e) {
      log('Error loading stories: $e');
    } finally {
      _isLoadingStories = false;
      notifyListeners();
    }
  }

  Future<void> loadBreathing() async {
    try {
      _isLoadingBreathing = true;
      notifyListeners();
      log('Loading breathing from collection: breaths');
      _breathing = await _data.getCMSContentByCollection(
        'breaths',
        page: 1,
        limit: 20,
        sort: 'createdAt',
      );
      log('Loaded ${_breathing.length} breathing items');
    } catch (e, stackTrace) {
      log('Error loading breathing: $e');
      log('Stack trace: $stackTrace');
      _breathing = [];
    } finally {
      _isLoadingBreathing = false;
      notifyListeners();
    }
  }

  Future<void> loadMeditation() async {
    try {
      _isLoadingMeditation = true;
      notifyListeners();
      // Try plural first (like yogas, stories)
      log('Loading meditation from collection: meditations');
      var result = await _data.getCMSContentByCollection(
        'meditations',
        page: 1,
        limit: 20,
        sort: 'createdAt',
      );
      // If empty, try singular (matching getMeditationUrl)
      if (result.isEmpty) {
        log('No results with plural, trying singular: meditation');
        result = await _data.getCMSContentByCollection(
          'meditation',
          page: 1,
          limit: 20,
          sort: 'createdAt',
        );
      }
      log('Loaded ${result.length} meditation items');
      _meditation = result;
    } catch (e, stackTrace) {
      log('Error loading meditation: $e');
      log('Stack trace: $stackTrace');
      _meditation = [];
    } finally {
      _isLoadingMeditation = false;
      notifyListeners();
    }
  }

  Future<void> loadYoga() async {
    try {
      _isLoadingYoga = true;
      notifyListeners();
      _yoga = await _data.getCMSContentByCollection(
        'yogas',
        page: 1,
        limit: 20,
        sort: 'createdAt',
      );
    } catch (e) {
      log('Error loading yoga: $e');
    } finally {
      _isLoadingYoga = false;
      notifyListeners();
    }
  }
}
