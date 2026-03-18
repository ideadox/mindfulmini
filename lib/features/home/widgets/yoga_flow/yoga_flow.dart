import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/yoga/data/yoga_data.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../../../core/api_constants.dart';
import '../../providers/home_provider.dart';

class YogaFlowWidget extends StatelessWidget {
  const YogaFlowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingYoga) {
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
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (provider.yoga.isEmpty) {
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
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.yoga.length,
                separatorBuilder: (context, index) => Space.w16,
                itemBuilder: (context, index) {
                  final yogaItem = provider.yoga[index];
                  if (yogaItem.cardImageFilename == null) {
                    return Container(
                      width: 177,
                      height: 268,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey.shade400,
                      ),
                    );
                  }

                  final imageUrl =
                      '${ApiConstants.mediaBaseUrl}${yogaItem.cardImageFilename}';

                  return InkWell(
                    onTap: () async {
                      try {
                        final yogaData = sl<YogaData>();
                        final yogaContent = await yogaData.getYogaContentById(
                          yogaItem.id,
                        );
                        if (context.mounted) {
                          sl<GoRouter>().pushNamed(
                            PlayVisuals.routeName,
                            extra: yogaContent,
                          );
                        }
                      } catch (e) {
                        log('Error fetching yoga content: $e');
                      }
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
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
