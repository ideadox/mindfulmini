import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/home/providers/home_provider.dart';
import 'package:mindfulminis/features/home/widgets/add_feeling/add_feeling_widget.dart';
import 'package:mindfulminis/features/home/widgets/breathing/breathing.dart';
import 'package:mindfulminis/features/home/widgets/daily_activity/daily_activity.dart';
import 'package:mindfulminis/features/home/widgets/meditation/meditation.dart';
import 'package:mindfulminis/features/home/widgets/my_routine/myroutine_slider.dart';
import 'package:mindfulminis/features/home/widgets/stories/stories.dart';
import 'package:mindfulminis/features/home/widgets/yoga_flow/yoga_flow.dart';
import 'package:mindfulminis/features/notifications/screens/notification_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../widgets/add_feeling/feeling_bar_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasRoutine = false;
    // context.read<RatingProvider>().showRatingDailog();

    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
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
                              icon: SvgPicture.asset(Assets.icons.notification),
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
                    // CreateRoutineButton(),
                    MyroutineSlider(),
                    Space.h32,

                    DailyActivityWidget(),
                    Space.h16,

                    YogaFlowWidget(),
                    Space.h16,

                    AddFeelingWidget(),
                    Space.h16,

                    FeelingBarChart(),

                    Space.h16,

                    MeditationWidget(),
                    Space.h16,

                    BreathingWidget(),
                    Space.h16,

                    StoriesWidget(),
                    SizedBox(height: kToolbarHeight + 40),
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
