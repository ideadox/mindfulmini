import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/collection_card_duration_badge.dart';
import '../../../../common/widgets/views_widget.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/app_formate.dart';
import '../../providers/home_provider.dart';

class BreathingWidget extends StatelessWidget {
  const BreathingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingBreathing) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.home('breathing.title', fallback: 'Breathing'),
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.home(
                    'breathing.subtitle',
                    fallback: 'Simple breathing meditations to relax young minds.',
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

        if (provider.breathing.isEmpty) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  strings.home('breathing.title', fallback: 'Breathing'),
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  strings.home(
                    'breathing.subtitle',
                    fallback: 'Simple breathing meditations to relax young minds.',
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
                          'breathing.empty_title',
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
                          'breathing.empty_subtitle',
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
                strings.home('breathing.title', fallback: 'Breathing'),
                style: AppTextTheme.titleTextTheme(context).titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                strings.home(
                  'breathing.subtitle',
                  fallback: 'Simple breathing meditations to relax young minds.',
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
                itemCount: provider.breathing.length,
                separatorBuilder: (context, index) => Space.w16,
                itemBuilder: (context, index) {
                  final breathingItem = provider.breathing[index];
                  return InkWell(
                    onTap: () {
                      sl<GoRouter>().pushNamed(
                        PlayVisuals.routeName,
                        queryParameters: {
                          'collection': 'breaths',
                          'id': breathingItem.id,
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
                              '${ApiConstants.mediaBaseUrl}${breathingItem.cardImageFilename ?? ''}',
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
                          child: ViewsWidget(totalViews: breathingItem.viewCount),
                        ),
                        if (breathingItem.estimatedDuration.inMinutes > 0)
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: CollectionCardDurationBadge(
                              label: AppFormate.formatReadDuration(
                                breathingItem.estimatedDuration,
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


   // return Column(
    //   children: [
    //     ListTile(
    //       contentPadding: EdgeInsets.zero,
    //       title: Text(
    //         'Breathing',
    //         style: AppTextTheme.titleTextTheme(
    //           context,
    //         ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
    //       ),
    //       subtitle: Text(
    //         'Quick Meditation for Kids to Calm Down.',
    //         style: AppTextTheme.bodyTextStyle(
    //           context,
    //         ).bodyMedium?.copyWith(fontSize: 12),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 268,
    //       child: ListView.separated(
    //         scrollDirection: Axis.horizontal,
    //         itemCount: 10,
    //         separatorBuilder: (context, index) {
    //           return Space.w16;
    //         },
    //         itemBuilder: (context, index) {
    //           return Container(
    //             width: 177,
    //             height: 268,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12),
    //             ),

    //             child: Image.asset(Assets.dummy.breathuing.path, height: 268),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );