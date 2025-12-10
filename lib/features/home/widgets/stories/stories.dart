import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mindfulminis/common/widgets/views_widget.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common/models/cms_model.dart';

class StoriesWidget extends StatelessWidget {
  const StoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.read<HomeProvider>();
    return PagingListener(
      controller: p.storiesController,
      builder: (context, state, fetchNextPage) {
        log(state.status.name.toString());
        log(state.keys?.length.toString() ?? 'null');

        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Short Stories',
                style: AppTextTheme.titleTextTheme(context).titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                'Calming stories to help kids unwind and relax.',
                style: AppTextTheme.bodyTextStyle(
                  context,
                ).bodyMedium?.copyWith(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 268,
              child: PagedListView<int, CmsModel>.separated(
                state: state,
                fetchNextPage: fetchNextPage,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Space.w16,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) {
                    final story = item;
                    return Stack(
                      children: [
                        Container(
                          width: 177,
                          height: 268,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: CachedNetworkImage(
                            imageUrl: Uri.encodeFull(
                              '${ApiConstants.mediaBaseUrl}/${story.media?.filename}',
                            ),

                            errorListener: (value) {},
                          ),
                        ),

                        Positioned(
                          right: 8,
                          top: 8,
                          child: ViewsWidget(totalViews: story.viewCount),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}





// Column(
//                     children: [
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         title: Text(
//                           'Short Stories',
//                           style: AppTextTheme.titleTextTheme(
//                             context,
//                           ).titleMedium?.copyWith(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Text(
//                           'Quick Short Stories for Kids to Calm Down.',
//                           style: AppTextTheme.bodyTextStyle(
//                             context,
//                           ).bodyMedium?.copyWith(fontSize: 12),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 268,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: stories.cmsContent.length,
//                           separatorBuilder: (context, index) {
//                             return Space.w16;
//                           },
//                           itemBuilder: (context, index) {
//                             final story = stories.cmsContent[index];
//                             return Container(
//                               width: 177,
//                               height: 268,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),

//                               child: CachedNetworkImage(
//                                 imageUrl:
//                                     '${ApiConstants.mediaBaseUrl}/${story.media?.filename}',
//                                 errorListener: (value) {
//                                   print(value);
//                                 },
//                               ),

//                               //  Image.asset(Assets.dummy.story.path, height: 268),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),