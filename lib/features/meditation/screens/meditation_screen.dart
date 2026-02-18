import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/meditation/providers/meditation_provider.dart';
import 'package:mindfulminis/features/meditation/screens/widgets/meditation_shimmer_loader.dart';
import 'package:mindfulminis/features/meditation/widgets/category_widget.dart';
import 'package:mindfulminis/features/meditation/widgets/suggestion_widgets.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

class MeditationScreen extends StatefulWidget {
  static String routeName = 'meditation-main';
  static String routePath = '/meditation-main';

  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch meditation sessions when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationProvider = Provider.of<MeditationProvider>(
        context,
        listen: false,
      );
      meditationProvider.fetchMeditationSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MeditationProvider>(
        builder: (context, provider, _) {
          // Show shimmer loader while loading
          if (provider.isLoading) {
            return const MeditationShimmerLoader();
          }

          return SingleChildScrollView(
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
                      SuggestionWidgets(meditationModel: provider.meditationSessions),
                      Space.h16,
                      //  const CategoryWidget(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
