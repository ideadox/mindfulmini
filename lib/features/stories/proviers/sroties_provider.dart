import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mindfulminis/common/data/cms_data.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/models/cms_model.dart';

class SrotiesProvider with ChangeNotifier {
  final _data = sl<CmsData>();
  late PagingController<int, CmsModel> _storiesController;

  PagingController<int, CmsModel> get storiesController => _storiesController;
  SrotiesProvider() {
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
}
