import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mindfulminis/features/breathing/data/breathing_data.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';

class BreathingProvider with ChangeNotifier {
  final BreathingData breathingData;

  // Tab management
  String currentTab = 'Morning';
  List<String> tabs = ['Morning', 'Afternoon', 'Evening'];

  // Breathing list state
  List<YogaContentModel> _breathingSessions = [];
  bool _isLoading = false;
  String? _error;

  BreathingProvider({required this.breathingData});

  // Getters
  List<YogaContentModel> get breathingSessions => _breathingSessions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void changeIndex(String val) {
    currentTab = val;
    notifyListeners();
  }

  Future<void> fetchBreathingSessions({
    int limitRaw = 20,
    int pageRaw = 1,
    String sortRaw = 'createdAt',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _breathingSessions = await breathingData.getBreathingSessions(
        limitRaw: limitRaw,
        pageRaw: pageRaw,
        sortRaw: sortRaw,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      SmartDialog.showToast(_error ?? 'Failed to load breathing exercises');
      log('❌ Breathing Provider Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
