import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../../../common/models/cms_model.dart';
import '../../../../common/widgets/views_widget.dart';
import '../../../../core/api_constants.dart';
import '../../providers/home_provider.dart';

class YogaFlowWidget extends StatelessWidget {
  const YogaFlowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.read<HomeProvider>();
    return PagingListener(
      controller: p.yogaController,
      builder: (context, state, fetchNextPage) {
        // log(state.status.name.toString());
        // log(state.keys?.length.toString() ?? 'null');
        // if (state.isLoading) {
        //   return const SizedBox(
        //     height: 268,
        //     child: Center(child: CircularProgressIndicator()),
        //   );
        // }

        // if (state.items == null || state.items!.isEmpty) {
        //   return const SizedBox.shrink(); // after loaded but no data
        // }

        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Yoga Flow',
                style: AppTextTheme.titleTextTheme(context).titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                'Quick Yoga sequence for kids to slow down',
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
  //   return Column(
  //     children: [
  //       ListTile(
  //         contentPadding: EdgeInsets.zero,
  //         title: Text(
  //           'Yoga Flow',
  //           style: AppTextTheme.titleTextTheme(
  //             context,
  //           ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
  //         ),
  //         subtitle: Text(
  //           'Quick Yoga sequence for kids to slow down',
  //           style: AppTextTheme.bodyTextStyle(
  //             context,
  //           ).bodyMedium?.copyWith(fontSize: 12),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 268,
  //         child: ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: 10,
  //           separatorBuilder: (context, index) {
  //             return Space.w16;
  //           },
  //           itemBuilder: (context, index) {
  //             return Container(
  //               width: 177,
  //               height: 268,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(12),
  //               ),

  //               child: SvgPicture.asset(Assets.dummy.yogaSvg, height: 268),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
