import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/stories/proviers/sroties_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/time_widget.dart';
import '../../../common/widgets/views_widget.dart';
import '../../../core/api_constants.dart';
import '../../../injection/injection.dart';
import '../../play visuals/screen/play_text.dart';
import '../../play visuals/screen/play_visuals.dart';

class ShortStories extends StatelessWidget {
  const ShortStories({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = context.read<SrotiesProvider>();
    return PagingListener(
      controller: stories.storiesController,
      builder: (context, state, fetchNextPage) {
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: PagedSliverGrid<int, CmsModel>(
            showNewPageProgressIndicatorAsGridChild: false,
            showNewPageErrorIndicatorAsGridChild: false,
            showNoMoreItemsIndicatorAsGridChild: false,
            state: state,
            fetchNextPage: fetchNextPage,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 100 / 140,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              crossAxisCount: 2,
            ),
            builderDelegate: PagedChildBuilderDelegate<CmsModel>(
              animateTransitions: true,
              itemBuilder:
                  (context, item, index) => InkWell(
                    onTap: () {
                      sl<GoRouter>().pushNamed(
                        PlayVisuals.routeName,

                        pathParameters: {
                          'collection': 'stories',
                          'id': item.id,
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 268,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                Uri.encodeFull(
                                  '${ApiConstants.mediaBaseUrl}/${item.media?.filename}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: TimeWidget(totalTime: 5),
                        ),

                        Positioned(
                          top: 10,
                          right: 10,
                          child: ViewsWidget(totalViews: 458),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        );
      },
    );
  }
}
