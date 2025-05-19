import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/stories/widgets/short_stories.dart';
import 'package:mindfulminis/features/stories/widgets/stories_categories.dart';
import 'package:mindfulminis/features/stories/widgets/suggestion_widget.dart';
import 'package:mindfulminis/features/yoga/widgets/create_calm/create_calm.dart';
import 'package:mindfulminis/features/yoga/widgets/deep_sleep/deep_sleep.dart';
import 'package:mindfulminis/features/yoga/widgets/featured_collection/featured_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/recent_collection/recent_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/starter_deck/starter_deck.dart';
import 'package:mindfulminis/features/yoga/widgets/warm-up/warm_up.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class StoriesScreen extends StatelessWidget {
  static String routeName = 'stories-main';
  static String routePath = '/stories-main';

  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(Assets.images.storiesTopHeader.path),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'Stories',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.titleTextTheme(
                          context,
                        ).titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      Space.h8,
                      Text(
                        'Engage your mind and heart with mindful tales!',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyTextStyle(
                          context,
                        ).bodyMedium?.copyWith(fontSize: 14),
                      ),
                      Space.h8,
                    ],
                  ),
                ),

                Positioned(
                  left: 12,
                  top: 50,
                  child: CustomBackButton(hasBackground: true),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SuggestionWidget(),
                  Space.h20,
                  StoriesCategories(),

                  Space.h20,

                  ShortStories(),
                  // Divider(thickness: 1, color: AppColors.dividerColor),

                  // StarterDeck(),
                  // Space.h20,
                  // Divider(thickness: 1, color: AppColors.dividerColor),
                  // WarmUp(),
                  // Space.h20,
                  // Divider(thickness: 1, color: AppColors.dividerColor),
                  // CreateCalm(),
                  // Space.h20,
                  // Divider(thickness: 1, color: AppColors.dividerColor),
                  // DeepSleep(),
                  Space.h20,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
