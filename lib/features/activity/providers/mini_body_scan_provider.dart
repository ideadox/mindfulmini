import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../common/data/cms_data.dart';
import '../../../common/models/cms_model.dart';
import '../../../injection/injection.dart';

class MiniBodyScanProvider with ChangeNotifier {
  final _data = sl<CmsData>();
  late PagingController<int, CmsModel> _storiesController;

  PagingController<int, CmsModel> get storiesController => _storiesController;
  MiniBodyScanProvider() {
    _storiesController = PagingController<int, CmsModel>(
      getNextPageKey:
          (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage:
          (pageKey) async => await _data.getCMSContentByCollection(
            'minibodyscans',
            page: pageKey,
            limit: 10,
            sort: 'createdAt',
          ),
    );
  }
}
