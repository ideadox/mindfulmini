import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mindfulminis/features/meditation/data/meditation_data.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';

class MeditationProvider with ChangeNotifier {
  final MeditationData meditationData;

  // Tab management
  String currentTab = 'Morning';
  List<String> tabs = ['Morning', 'Afternoon', 'Evening'];

  // Meditation list state
  List<YogaContentModel> _meditationSessions = [];
  bool _isLoading = false;
  String? _error;

  MeditationProvider({required this.meditationData});

  // Getters
  List<YogaContentModel> get meditationSessions => _meditationSessions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void changeIndex(String val) {
    currentTab = val;
    notifyListeners();
  }

  Future<void> fetchMeditationSessions({
    int limitRaw = 20,
    int pageRaw = 1,
    String sortRaw = 'createdAt',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _meditationSessions = await meditationData.getMeditationSessions(
        limitRaw: limitRaw,
        pageRaw: pageRaw,
        sortRaw: sortRaw,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      SmartDialog.showToast(_error ?? 'Failed to load meditations');
      log('❌ Meditation Provider Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
