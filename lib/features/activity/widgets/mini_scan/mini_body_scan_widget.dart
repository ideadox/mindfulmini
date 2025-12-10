import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/activity/providers/mini_body_scan_provider.dart';
import 'package:mindfulminis/features/activity/widgets/activity_home_card.dart';

import 'package:provider/provider.dart';

import '../../../../common/models/cms_model.dart';
import '../../../../core/api_constants.dart';

class MiniBodyScanWidget extends StatelessWidget {
  const MiniBodyScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Consumer<MiniBodyScanProvider>(
      builder: (context, p, _) {
        return PagingListener(
          controller: p.storiesController,
          builder: (context, state, fetchNextPage) {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Mini Body Scan',
                    style: AppTextTheme.titleTextTheme(context).titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Text(
                    'Welcome to your little yogis first flow',
                    style: AppTextTheme.bodyTextStyle(
                      context,
                    ).bodyMedium?.copyWith(fontSize: 12),
                  ),
                ),
                Space.h12,

                // SizedBox(
                //   height: height * 0.4,
                //   child: ListView.separated(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: 10,
                //     separatorBuilder: (context, index) {
                //       return Space.w16;
                //     },
                //     itemBuilder: (context, index) {
                //       return SizedBox(
                //         height: double.infinity,
                //         width: width * 0.6,
                //         child: ActivityHomeCard(
                //           image: Assets.dummy.scanActivity.path,
                //         ),
                //       );
                //     },
                //   ),
                // ),
                SizedBox(
                  height: height * 0.4,
                  child: PagedListView<int, CmsModel>.separated(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => Space.w16,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                        return SizedBox(
                          height: double.infinity,
                          width: width * 0.6,
                          child: ActivityHomeCard(
                            isNetwrok: true,
                            image: Uri.encodeFull(
                              '${ApiConstants.mediaBaseUrl}/${item.media?.filename}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
