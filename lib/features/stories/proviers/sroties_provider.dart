import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mindfulminis/common/data/cms_data.dart';
import 'package:mindfulminis/features/stories/data/stories_data.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/models/cms_model.dart';

class SrotiesProvider with ChangeNotifier {
  final StoriesData storiesData;
  final _data = sl<CmsData>();
  late PagingController<int, CmsModel> _storiesController;
  List<YogaContentModel> _storiesSessions = [];
  List<YogaContentModel> get storiesSessions => _storiesSessions;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;

  PagingController<int, CmsModel> get storiesController => _storiesController;
  SrotiesProvider({required this.storiesData}) {
    _storiesController = PagingController<int, CmsModel>(
      getNextPageKey:
          (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage:
          (pageKey) async => await _data.getCMSContentByCollection(
            'stories',
            page: pageKey,
            limit: 10,
            sort: 'createdAt',
          ),
    );
  }

  Future<void> fetchStoriesSessions({
    int limitRaw = 20,
    int pageRaw = 1,
    String sortRaw = 'createdAt',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _storiesSessions = await storiesData.getStoriesSessions(
        limitRaw: limitRaw,
        pageRaw: pageRaw,
        sortRaw: sortRaw,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      // SmartDialog.showToast(_error ?? 'Failed to load stories');
      log('❌ Stories Provider Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
