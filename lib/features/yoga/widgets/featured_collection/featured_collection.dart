import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/yoga/data/yoga_data.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/yoga/models/yoga_model.dart';
import 'package:mindfulminis/features/yoga/screens/yoga_list.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class FeaturedCollection extends StatelessWidget {
  final List<YogaModel> featuredPoses;
  const FeaturedCollection({super.key, required this.featuredPoses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Featured Flow',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 303,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: featuredPoses.length,
            separatorBuilder: (context, index) {
              return Space.w16;
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  log(featuredPoses[index].id!);
                  try {
                    final yogaData = sl<YogaData>();
                    final yogaContent = await yogaData.getYogaContentById(
                      featuredPoses[index].id,
                    );
                    sl<GoRouter>().pushNamed(
                      YogaList.routeName,
                      extra: yogaContent,
                    );
                  } catch (e) {
                    log('Error fetching yoga content: $e');
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 296,
                          height: 268,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: CachedNetworkImage(
                            imageUrl:
                                ApiConstants.mediaBaseUrl +
                                featuredPoses[index].media!['filename']
                                    .toString(),
                            fit: BoxFit.cover,
                          ),
                          // SvgPicture.asset(Assets.dummy.frame2043683273),
                        ),
                        // Positioned(bottom: 50, left: 16, child: TotalTimingWidget()),
                      ],
                    ),

                    Text('6 Poses', style: TextStyle(color: Colors.black45)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
