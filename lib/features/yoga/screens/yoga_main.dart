import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/yoga/providers/yoga_provider.dart';
import 'package:mindfulminis/features/yoga/screens/widgets/shimmer_loader.dart';
import 'package:mindfulminis/features/yoga/widgets/create_calm/create_calm.dart';
import 'package:mindfulminis/features/yoga/widgets/deep_sleep/deep_sleep.dart';
import 'package:mindfulminis/features/yoga/widgets/featured_collection/featured_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/recent_collection/recent_collection.dart';
import 'package:mindfulminis/features/yoga/widgets/starter_deck/starter_deck.dart';
import 'package:mindfulminis/features/yoga/widgets/warm-up/warm_up.dart';
import 'package:mindfulminis/features/yoga/widgets/yoga_picks/yoga_picks.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

class YogaMain extends StatefulWidget {
  static String routeName = 'yoga-main';
  static String routePath = '/yoga-main';

  const YogaMain({super.key});

  @override
  State<YogaMain> createState() => _YogaMainState();
}

class _YogaMainState extends State<YogaMain> {
  @override
  void initState() {
    super.initState();
    // Fetch yoga poses when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final yogaProvider = Provider.of<YogaProvider>(context, listen: false);
      yogaProvider.fetchYogaPoses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<YogaProvider>(
        builder: (context, yogaProvider, child) {
          // Show shimmer loader while loading
          if (yogaProvider.isLoading) {
            return const ShimmerLoader();
          }

          // Show main content
          return Stack(
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
                                Assets.images.yogaTopBackgroud.path,
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
                            'Inspire movement, balance, and joyful focus through playful poses.',
                            textAlign: TextAlign.center,
                            style: AppTextTheme.bodyTextStyle(
                              context,
                            ).bodyMedium?.copyWith(fontSize: 14),
                          ),
                          Space.h12,
                        //  RecentCollection(),
                          Space.h16,
                       //   YogaPicks(),
                          Space.h16,
                          FeaturedCollection(featuredPoses: yogaProvider.yogaPoses),
                          Space.h16,
                         // StarterDeck(),
                          Space.h16,
                          //WarmUp(),
                          Space.h16,
                          //CreateCalm(),
                          Space.h16,
                          //DeepSleep(),
                          Space.h16,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
