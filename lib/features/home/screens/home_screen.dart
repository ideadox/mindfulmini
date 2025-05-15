import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/home/widgets/add_feeling/add_feeling_widget.dart';
import 'package:mindfulminis/features/home/widgets/breathing/breathing.dart';
import 'package:mindfulminis/features/home/widgets/daily_activity/daily_activity.dart';
import 'package:mindfulminis/features/home/widgets/meditation/meditation.dart';
import 'package:mindfulminis/features/home/widgets/stories/stories.dart';
import 'package:mindfulminis/features/home/widgets/yoga_flow/yoga_flow.dart';
import 'package:mindfulminis/features/routine/widgets/myroutine_brief_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../widgets/create_routine_button/create_routine_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
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
                            onPressed: () {},
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
                  // CreateRoutineButton(),
                  Text(
                    'Your Routine',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Your own mindful routine for a calm and happy day',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey45,
                    ),
                  ),
                  Space.h12,
                  MyroutineBriefCard(formHome: true),
                  Space.h20,
                  DailyActivityWidget(),
                  Space.h20,
                  Divider(thickness: 1, color: AppColors.dividerColor),

                  YogaFlowWidget(),
                  Space.h20,
                  Divider(thickness: 1, color: AppColors.dividerColor),
                  Space.h20,

                  AddFeelingWidget(),
                  Space.h20,
                  Divider(thickness: 1, color: AppColors.dividerColor),
                  MeditationWidget(),
                  Space.h20,

                  Divider(thickness: 1, color: AppColors.dividerColor),

                  BreathingWidget(),
                  Space.h20,

                  Divider(thickness: 1, color: AppColors.dividerColor),

                  StoriesWidget(),
                  SizedBox(height: kToolbarHeight + 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
