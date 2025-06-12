import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/stories/widgets/short_stories.dart';
import 'package:mindfulminis/features/stories/widgets/stories_categories.dart';
import 'package:mindfulminis/features/stories/widgets/suggestion_widget.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../mini_audio_player/screens/minimize_player.dart';

class StoriesScreen extends StatelessWidget {
  static String routeName = 'stories-main';
  static String routePath = '/stories-main';

  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            Assets.images.storyTopBackground.path,
                          ),
                        ),
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
                      Space.h4,
                      Text(
                        'Spark imagination, curiosity, and emotional learning through tales.',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyTextStyle(
                          context,
                        ).bodyMedium?.copyWith(fontSize: 14),
                      ),
                      Space.h8,
                      SuggestionWidget(),
                      Space.h16,
                      StoriesCategories(),

                      Space.h16,

                      ShortStories(),

                      Space.h20,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: MiniAudioPlayer()),
        ],
      ),
    );
  }
}
