import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/features/yoga/data/yoga_data.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';

/// YogaListProvider - Dedicated provider for YogaList screen
/// This provider is used to manage yoga content state for the YogaList screen
/// It can be extended in the future for additional functionality specific to the yoga list view
class YogaListProvider with ChangeNotifier {
  final YogaData yogaData;

  // Content-specific state
  YogaContentModel? _selectedContent;
  bool _isContentLoading = false;
  String? _contentError;

  YogaListProvider({required this.yogaData});

  // Content getters
  YogaContentModel? get selectedContent => _selectedContent;
  bool get isContentLoading => _isContentLoading;
  String? get contentError => _contentError;

  /// Set the yoga content directly (used when content is passed via route)
  void setYogaContent(YogaContentModel content) {
    _selectedContent = content;
    _contentError = null;
    notifyListeners();
  }

  /// Fetch yoga content by ID (for future use if needed)
  Future<void> fetchYogaContent(String id) async {
    _isContentLoading = true;
    _contentError = null;
    notifyListeners();

    try {
      _selectedContent = await yogaData.getYogaContentById(id);
    } catch (e) {
      _contentError = e.toString();
      log('Yoga List Provider Error: $_contentError');
    } finally {
      _isContentLoading = false;
      notifyListeners();
    }
  }

  /// Clear the content
  void clearContent() {
    _selectedContent = null;
    _contentError = null;
    notifyListeners();
  }
}
