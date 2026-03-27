import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/views_widget.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';
import '../../../../core/api_constants.dart';
import '../../providers/home_provider.dart';

class MeditationWidget extends StatelessWidget {
  const MeditationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingMeditation) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Meditation',
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  'Gentle meditations to help kids relax and feel at ease',
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

        if (provider.meditation.isEmpty) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Meditation',
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  'Gentle meditations to help kids relax and feel at ease',
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
                        'No items found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'The list is currently empty.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
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
                'Meditation',
                style: AppTextTheme.titleTextTheme(context).titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                'Gentle meditations to help kids relax and feel at ease',
                style: AppTextTheme.bodyTextStyle(
                  context,
                ).bodyMedium?.copyWith(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 268,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.meditation.length,
                separatorBuilder: (context, index) => Space.w16,
                itemBuilder: (context, index) {
                  final meditationItem = provider.meditation[index];
                  return InkWell(
                    onTap: () {
                      sl<GoRouter>().pushNamed(
                        PlayVisuals.routeName,
                        queryParameters: {
                          'collection': 'meditations',
                          'id': meditationItem.id,
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
                              '${ApiConstants.mediaBaseUrl}${meditationItem.cardImageFilename ?? ''}',
                            ),
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
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
                            errorWidget:
                                (context, url, error) => Container(
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
                          child: ViewsWidget(totalViews: meditationItem.viewCount),
                        ),
                        if (meditationItem.estimatedDuration.inMinutes > 0)
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                AppFormate.formatReadDuration(meditationItem.estimatedDuration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
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


  //   return Column(
  //     children: [
  //       ListTile(
  //         contentPadding: EdgeInsets.zero,
  //         title: Text(
  //           'Meditation',
  //           style: AppTextTheme.titleTextTheme(
  //             context,
  //           ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
  //         ),
  //         subtitle: Text(
  //           'Quick Meditation for Kids to Calm Down.',
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

  //               child: Image.asset(Assets.dummy.medit.path, height: 268),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }