import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/activity/widgets/activity_home_card.dart';
import 'package:mindfulminis/features/breathing/screens/breathing_screen.dart';
import 'package:mindfulminis/features/meditation/screens/meditation_screen.dart';
import 'package:mindfulminis/features/stories/screens/stories_screen.dart';
import 'package:mindfulminis/features/yoga/screens/yoga_main.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';

import '../../../core/app_text_theme.dart';
import 'package:mindfulminis/features/mini_body_scan/screens/mini_body_scan_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Space.h40,
              Space.h8,
              Text(
                'Explore',
                textAlign: TextAlign.center,
                style: AppTextTheme.titleTextTheme(context).titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Space.h4,
              Text(
                'Your Path to Happiness Starts Here',
                textAlign: TextAlign.center,
                style: AppTextTheme.bodyTextStyle(
                  context,
                ).bodyMedium?.copyWith(fontSize: 12),
              ),
              Space.h16,
              SizedBox(
                height: 180,
                width: double.infinity,
                child: ActivityHomeCard(
                  onTap: () {
                    sl<GoRouter>().pushNamed(MiniBodyScanScreen.routeName);
                  },
                  image: Assets.images.placeholders.exploreBodyscanBanner.path,
                ),
              ),
              Space.h12,
              SizedBox(
                height: height * 0.5,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: ActivityHomeCard(
                        onTap: () {
                          sl<GoRouter>().pushNamed(YogaMain.routeName);
                        },
                        image: Assets.images.placeholders.exploreYogaBanner.path,
                      ),
                    ),
                    Space.w12,
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ActivityHomeCard(
                              onTap: () {
                                sl<GoRouter>().pushNamed(
                                  MeditationScreen.routeName,
                                );
                              },
                              image: Assets.images.placeholders
                                  .exploreMeditationBanner.path,
                            ),
                          ),
                          Space.h12,
                          Expanded(
                            child: ActivityHomeCard(
                              onTap: () {
                                sl<GoRouter>().pushNamed(
                                  StoriesScreen.routeName,
                                );
                              },
                              image: Assets.images.placeholders
                                  .exploreStoriesBanner.path,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Space.h12,
              SizedBox(
                height: 180,
                width: double.infinity,
                child: ActivityHomeCard(
                  onTap: () {
                    sl<GoRouter>().pushNamed(BreathingScreen.routeName);
                  },
                  image: Assets.images.placeholders.exploreBreathingBanner.path,
                ),
              ),
              SizedBox(height: kToolbarHeight + 40),
            ],
          ),
        ),
      ),
    );
  }
}
