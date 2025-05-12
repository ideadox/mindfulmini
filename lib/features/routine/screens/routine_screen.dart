import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../widgets/horizontal_week_calender.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 515,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        Assets.images.routineTopBackground.path,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      Text(
                        'Daily Routine',
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
                        'Create your mindful routine for a peaceful day.',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyTextStyle(
                          context,
                        ).bodyMedium?.copyWith(fontSize: 14),
                      ),
                      Space.h8,
                      SizedBox(
                        width: 170,
                        height: 48,
                        child: GradientButton(
                          onPressed: () {},
                          child: Center(
                            child: Text(
                              'Create Now',
                              style:
                                  AppTextTheme.mainButtonTextStyle(
                                    context,
                                  ).titleLarge,
                            ),
                          ),
                        ),
                      ),
                      Space.h32,
                      Text(
                        'Ready to Create Task',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyTextStyle(
                          context,
                        ).bodyMedium?.copyWith(fontSize: 14),
                      ),
                      Space.h4,

                      Text(
                        'Get Started',
                        style: AppTextTheme.titleTextTheme(
                          context,
                        ).titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Space.h40,

            // Space.h40,
            HorizontalWeekCalendar(
              selectedDate: DateTime.now(),
              onDateSelected: (date) {},
            ),
          ],
        ),
      ),
    );
  }
}
