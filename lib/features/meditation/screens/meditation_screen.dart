import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';

import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/meditation/providers/meditation_provider.dart';
import 'package:mindfulminis/features/meditation/widgets/category_widget.dart';
import 'package:mindfulminis/features/meditation/widgets/suggestion_widgets.dart';
import 'package:mindfulminis/features/yoga/widgets/create_calm/create_calm.dart';
import 'package:mindfulminis/features/yoga/widgets/deep_sleep/deep_sleep.dart';
import 'package:mindfulminis/features/yoga/widgets/featured_collection/featured_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/recent_collection/recent_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/starter_deck/starter_deck.dart';
import 'package:mindfulminis/features/yoga/widgets/warm-up/warm_up.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class MeditationScreen extends StatelessWidget {
  static String routeName = 'meditation-main';
  static String routePath = '/meditation-main';

  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MeditationProvider(),
      child: Scaffold(
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
                        image: AssetImage(
                          Assets.images.meditationTopHrader.path,
                        ),
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
                          'Meditation',
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
                    SuggestionWidgets(),

                    Space.h20,
                    Divider(thickness: 1, color: AppColors.dividerColor),

                    Space.h20,

                    CategoryWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
