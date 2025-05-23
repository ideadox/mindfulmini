import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';

import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/breathing/providers/breathing_provider.dart';
import 'package:mindfulminis/features/breathing/widgets/breathing_category.dart';
import 'package:mindfulminis/features/breathing/widgets/breathing_suggestion.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class BreathingScreen extends StatelessWidget {
  static String routeName = 'breadthing-main';
  static String routePath = '/breadthing-main';

  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BreathingProvider(),
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
                          Assets.images.breathingTopHeader.path,
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
                          'Breathing Exercise',
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
                    BreathingSuggestion(),

                    Space.h20,
                    Divider(thickness: 1, color: AppColors.dividerColor),

                    Space.h20,

                    BreathingCategory(),
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
