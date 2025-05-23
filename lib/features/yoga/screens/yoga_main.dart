import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/yoga/widgets/create_calm/create_calm.dart';
import 'package:mindfulminis/features/yoga/widgets/deep_sleep/deep_sleep.dart';
import 'package:mindfulminis/features/yoga/widgets/featured_collection/featured_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/recent_collection/recent_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/starter_deck/starter_deck.dart';
import 'package:mindfulminis/features/yoga/widgets/warm-up/warm_up.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class YogaMain extends StatelessWidget {
  static String routeName = 'yoga-main';
  static String routePath = '/yoga-main';

  const YogaMain({super.key});

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
                      image: AssetImage(Assets.images.yogaMainHeader.path),
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
                        'Yoga',
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
                        'Gentle exercises to help kids let go of negative emotions, nurturing their health, strength, and confidence.',
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
                  RecentCollection(),
                  Space.h20,
                  FeaturedCollection(),
                  Space.h20,
                  Divider(thickness: 1, color: AppColors.dividerColor),

                  StarterDeck(),
                  Space.h20,
                  Divider(thickness: 1, color: AppColors.dividerColor),
                  WarmUp(),
                  Space.h20,
                  Divider(thickness: 1, color: AppColors.dividerColor),
                  CreateCalm(),
                  Space.h20,
                  Divider(thickness: 1, color: AppColors.dividerColor),
                  DeepSleep(),
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
