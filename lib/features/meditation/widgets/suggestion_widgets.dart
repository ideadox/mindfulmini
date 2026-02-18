import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';

import '../../play_visuals/screen/play_visuals.dart';

class SuggestionWidgets extends StatelessWidget {
  final List<YogaContentModel> meditationModel;
  const SuggestionWidgets({super.key, required this.meditationModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Suggested For You',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            'Short meditations to help kids slow down and feel calm',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ),
        SizedBox(
          height: 268,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: meditationModel.length,
            separatorBuilder: (context, index) {
              return Space.w16;
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Navigate to meditation detail with collection and id
                  sl<GoRouter>().pushNamed(
                    PlayVisuals.routeName,
                    queryParameters: {
                      'collection': 'meditations',
                      'id': meditationModel[index].id,
                    },
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: 216,
                      height: 268,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            ApiConstants.mediaBaseUrl +
                            meditationModel[index].media!['filename'],
                      ),
                      // Image.asset(
                      //   Assets.dummy.meditationSuggestionCard.path,
                      // ),
                    ),
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
