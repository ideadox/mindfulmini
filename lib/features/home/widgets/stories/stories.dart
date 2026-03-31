import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/collection_card_duration_badge.dart';
import 'package:mindfulminis/common/widgets/views_widget.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/home/providers/home_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:provider/provider.dart';

class StoriesWidget extends StatelessWidget {
  const StoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingStories) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.home('stories.title', fallback: 'Short Stories'),
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.home(
                    'stories.subtitle',
                    fallback: 'Calming stories to help kids unwind and relax.',
                  ),
                  style: AppTextTheme.bodyTextStyle(
                    context,
                  ).bodyMedium?.copyWith(fontSize: 12),
                ),
              ),
              SizedBox(
                height: 268,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (provider.stories.isEmpty) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.home('stories.title', fallback: 'Short Stories'),
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.home(
                    'stories.subtitle',
                    fallback: 'Calming stories to help kids unwind and relax.',
                  ),
                  style: AppTextTheme.bodyTextStyle(
                    context,
                  ).bodyMedium?.copyWith(fontSize: 12),
                ),
              ),
              SizedBox(
                height: 268,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        strings.home(
                          'stories.empty_title',
                          fallback: 'No items found',
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        strings.home(
                          'stories.empty_subtitle',
                          fallback: 'The list is currently empty.',
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                strings.home('stories.title', fallback: 'Short Stories'),
                style: AppTextTheme.titleTextTheme(context).titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                strings.home(
                  'stories.subtitle',
                  fallback: 'Calming stories to help kids unwind and relax.',
                ),
                style: AppTextTheme.bodyTextStyle(
                  context,
                ).bodyMedium?.copyWith(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 268,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.stories.length,
                separatorBuilder: (context, index) => Space.w16,
                itemBuilder: (context, index) {
                  final storyItem = provider.stories[index];
                  return InkWell(
                    onTap: () {
                      sl<GoRouter>().pushNamed(
                        PlayVisuals.routeName,
                        queryParameters: {
                          'collection': 'stories',
                          'id': storyItem.id,
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          width: 177,
                          height: 268,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: Uri.encodeFull(
                              '${ApiConstants.mediaBaseUrl}${storyItem.cardImageFilename ?? ''}',
                            ),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey.shade400,
                          ),
                        ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: ViewsWidget(totalViews: storyItem.viewCount),
                        ),
                        if (storyItem.estimatedDuration.inMinutes > 0)
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: CollectionCardDurationBadge(
                              label: AppFormate.formatReadDuration(
                                storyItem.estimatedDuration,
                              ),
                            ),
                          ),
                      ],
                    ),
                    );
                  },
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