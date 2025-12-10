import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/features/home/data/home_data.dart';
import 'package:mindfulminis/injection/injection.dart';

class HomeProvider with ChangeNotifier {
  final _data = sl<HomeData>();

  bool isLoading = false;

  List<CmsModel> cmsContent = [];

  late PagingController<int, CmsModel> _storiesController;
  late PagingController<int, CmsModel> _breathingController;
  late PagingController<int, CmsModel> _meditationController;
  late PagingController<int, CmsModel> _yogaController;
  late PagingController<int, CmsModel> _dailyActivityController;

  PagingController<int, CmsModel> get storiesController => _storiesController;
  PagingController<int, CmsModel> get breathingController =>
      _breathingController;
  PagingController<int, CmsModel> get meditationController =>
      _meditationController;
  PagingController<int, CmsModel> get yogaController => _yogaController;
  PagingController<int, CmsModel> get dailyActivityController =>
      _dailyActivityController;

  HomeProvider() {
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
    _breathingController = PagingController<int, CmsModel>(
      getNextPageKey:
          (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage:
          (pageKey) async => await _data.getCMSContentByCollection(
            'breathings',
            page: pageKey,
            limit: 10,
            sort: 'createdAt',
          ),
    );

    _meditationController = PagingController<int, CmsModel>(
      getNextPageKey:
          (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage:
          (pageKey) async => await _data.getCMSContentByCollection(
            'meditations',
            page: pageKey,
            limit: 10,
            sort: 'createdAt',
          ),
    );

    _yogaController = PagingController<int, CmsModel>(
      getNextPageKey:
          (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage:
          (pageKey) async => await _data.getCMSContentByCollection(
            'yogas',
            page: pageKey,
            limit: 10,
            sort: 'createdAt',
          ),
    );
  }
}
