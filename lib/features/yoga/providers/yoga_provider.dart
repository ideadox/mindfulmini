import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/features/yoga/data/yoga_data.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/yoga/models/yoga_model.dart';

class YogaProvider with ChangeNotifier {
  final YogaData yogaData;

  bool _isLoading = false;
  List<YogaModel> _yogaPoses = [];
  String? _error;

  // Content-specific state
  YogaContentModel? _selectedContent;
  bool _isContentLoading = false;
  String? _contentError;

  YogaProvider({required this.yogaData});

  bool get isLoading => _isLoading;
  List<YogaModel> get yogaPoses => _yogaPoses;
  String? get error => _error;

  // Content getters
  YogaContentModel? get selectedContent => _selectedContent;
  bool get isContentLoading => _isContentLoading;
  String? get contentError => _contentError;

  Future<void> fetchYogaPoses({
    int limitRaw = 20,
    int pageRaw = 1,
    String sortRaw = 'createdAt',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _yogaPoses = await yogaData.getYogaPoses(
        limitRaw: limitRaw,
        pageRaw: pageRaw,
        sortRaw: sortRaw,
      );
    } catch (e) {
      _error = e.toString();
      log('Yoga Provider Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchYogaContent(String id) async {
    _isContentLoading = true;
    _contentError = null;
    notifyListeners();

    try {
      _selectedContent = await yogaData.getYogaContentById(id);
    } catch (e) {
      _contentError = e.toString();
      log('Yoga Content Provider Error: $_contentError');
    } finally {
      _isContentLoading = false;
      notifyListeners();
    }
  }
}
