import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/meditation/providers/meditation_provider.dart';
import 'package:mindfulminis/features/meditation/widgets/category_widget.dart';
import 'package:mindfulminis/features/meditation/widgets/suggestion_widgets.dart';
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
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          Assets.images.medatationTopBackground.path,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
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
                        Space.h4,
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
                    Text(
                      'A gentle pause for peace, smiles, and self-love.',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.bodyTextStyle(
                        context,
                      ).bodyMedium?.copyWith(fontSize: 14),
                    ),
                    Space.h8,
                    SuggestionWidgets(),
                    Space.h16,
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
