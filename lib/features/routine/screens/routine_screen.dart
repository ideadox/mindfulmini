import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/routine/screens/create_routine_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../providers/routine_provider.dart';
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
                      Space.h4,
                      Text(
                        'Create your mindful routine for a peaceful day.',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyTextStyle(context).bodyMedium
                            ?.copyWith(fontSize: 14, color: Colors.black54),
                      ),
                      Space.h4,
                      SizedBox(
                        width: 170,
                        height: 48,
                        child: GradientButton(
                          onPressed: () async {
                            await sl<GoRouter>().pushNamed(
                              CreateRoutineScreen.routeName,
                            );
                            if (context.mounted) {
                              context.read<RoutineProvider>().getRoutines(
                                notify: false,
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              'Create Now',
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
                      Space.h32,

                      Space.h4,
                    ],
                  ),
                ),
              ],
            ),

            HorizontalWeekCalendar(
              selectedDate: DateTime.now(),
              onDateSelected: (date) {},
            ),
            Space.h40,
            Space.h40,
          ],
        ),
      ),
    );
  }
}
