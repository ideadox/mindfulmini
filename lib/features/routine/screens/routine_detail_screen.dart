import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/custom_precentage_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/routine/widgets/horizontal_week_calender.dart';
import 'package:mindfulminis/features/routine/widgets/routine_level_container.dart';

class RoutineDetailScreen extends StatelessWidget {
  static String routeName = 'routine-detail-screen';
  static String routePath = '/routine-detail-screen';
  const RoutineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Space.h40,
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomBackButton(hasBackground: true),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Morning Routine',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        'Your program is ready!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // CircularProgressIndicator(value: 0.3),
                CustomPrecentageIndicator(percent: 0.40),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Space.h20,
                  HorizontalWeekCalendar(
                    selectedDate: DateTime.now(),
                    onDateSelected: (date) {},
                  ),

                  Space.h20,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Space.h20,
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  int activeIndex = 1;

                                  return Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                        height: index == 4 ? 0 : 108,
                                        width: 4,

                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: HexColor(
                                                '#E9CDFF',
                                              ).withOpacity(0.7),
                                              spreadRadius: 1,
                                              blurRadius: 12,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                          color:
                                              activeIndex > index
                                                  ? null
                                                  : HexColor('#E9CDFF'),
                                          gradient:
                                              activeIndex <= index
                                                  ? null
                                                  : LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,

                                                    colors:
                                                        AppColors
                                                            .primaryGradientColors,
                                                  ),
                                        ),
                                      ),

                                      Positioned(
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            color:
                                                activeIndex > index
                                                    ? null
                                                    : HexColor('#E9CDFF'),
                                            gradient:
                                                activeIndex < index
                                                    ? null
                                                    : LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end:
                                                          Alignment
                                                              .bottomCenter,

                                                      colors:
                                                          AppColors
                                                              .primaryGradientColors,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            separatorBuilder: (context, index) => Space.h16,
                            itemBuilder: (context, index) {
                              return RoutineLevelContainer(
                                isCompleted: index == 0,
                                currentLevel: index == 1,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
