import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/home/providers/home_provider.dart';
import 'package:mindfulminis/features/home/widgets/add_feeling/add_feeling_widget.dart';
import 'package:mindfulminis/features/home/widgets/breathing/breathing.dart';
import 'package:mindfulminis/features/home/widgets/daily_activity/daily_activity.dart';
import 'package:mindfulminis/features/home/widgets/meditation/meditation.dart';
import 'package:mindfulminis/features/home/widgets/my_routine/myroutine_slider.dart';
import 'package:mindfulminis/features/home/widgets/stories/stories.dart';
import 'package:mindfulminis/features/home/widgets/yoga_flow/yoga_flow.dart';
import 'package:mindfulminis/features/notifications/screens/notification_screen.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/features/routine/screens/create_routine_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

import '../providers/active_routine_provider.dart';
import '../widgets/add_feeling/feeling_bar_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // bool hasRoutine = false;
    // context.read<RatingProvider>().showRatingDailog();

    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => ActiveRoutineProvider()),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Consumer2<ProfileProvider, HomeProvider>(
          builder: (context, pp, hp, _) {
            // Only show loading if profile is actually loading
            if (pp.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Critical: If profile is missing after loading completes, log out immediately
            // But only if not already logging out to prevent multiple calls
            if (!pp.loading && pp.userProfile == null && !pp.isLoggingOut) {
              // Use WidgetsBinding to avoid calling in build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  log('❌ Profile is missing in HomeScreen - logging out user');
                  context.read<ProfileProvider>().logOutUser();
                }
              });
              // Show loading while logout is in progress
              return const Center(child: CircularProgressIndicator());
            }
            
            // Show loading while logout is in progress
            if (pp.isLoggingOut) {
              return const Center(child: CircularProgressIndicator());
            }

            // If profile loaded successfully, get routines
            if (!pp.loading && pp.userProfile != null) {
              // Use WidgetsBinding to avoid calling in build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  context.read<ActiveRoutineProvider>().getRoutines(
                    pp.userProfile!.id,
                    notify: false,
                  );
                }
              });
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: AssetImage(Assets.images.header.path),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: kToolbarHeight),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: SvgPicture.asset(
                                Assets.icons.homeTopLogo,
                                width: 70,
                                height: 40,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 48),
                                IconButton(
                                  onPressed: () {
                                    sl<GoRouter>().pushNamed(
                                      NotificationScreen.routeName,
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    Assets.icons.notification,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Space.h12,
                        Consumer2<ActiveRoutineProvider, ProfileProvider>(
                          builder: (context, p, pp, _) {
                            if (p.routines.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: SizedBox(
                                  width: 170,
                                  height: 48,
                                  child: GradientButton(
                                    onPressed: () async {
                                      await sl<GoRouter>().pushNamed(
                                        CreateRoutineScreen.routeName,
                                      );
                                      if (context.mounted &&
                                          pp.userProfile != null) {
                                        context
                                            .read<ActiveRoutineProvider>()
                                            .getRoutines(
                                              pp.userProfile!.id,
                                              notify: false,
                                            );
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        'Create Routine',
                                        style: AppTextTheme.mainButtonTextStyle(
                                          context,
                                        ).titleLarge?.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return MyroutineSlider();
                          },
                        ),
                        Space.h32,

                        DailyActivityWidget(),
                        Space.h16,

                        YogaFlowWidget(),
                        Space.h16,

                        // AddFeelingWidget(),
                        // Space.h16,

                        // FeelingBarChart(),

                        // Space.h16,

                        MeditationWidget(),
                        Space.h16,

                        BreathingWidget(),
                        Space.h16,
                        StoriesWidget(),
                        Space.h16,

                        SizedBox(height: kToolbarHeight + 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
