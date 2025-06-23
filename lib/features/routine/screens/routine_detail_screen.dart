import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/custom_precentage_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/routine/providers/routine_activity_provider.dart';
import 'package:mindfulminis/features/routine/widgets/horizontal_week_calender.dart';
import 'package:mindfulminis/features/routine/widgets/routine_level_container.dart';
import 'package:provider/provider.dart';

class RoutineDetailScreen extends StatelessWidget {
  static String routeName = 'routine-detail-screen';
  static String routePath = '/routine-detail-screen/:routineId';
  final String routineId;
  const RoutineDetailScreen({super.key, required this.routineId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => RoutineActivityProvider(
            routineId,
            DateFormat('yyyy-MM-dd').format(DateTime.now()),
          ),

      child: Scaffold(
        body: Consumer<RoutineActivityProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
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
                          selectedDate: provider.selectedDate,
                          onDateSelected: (date) {
                            provider.selectDate(date);
                            provider.getRoutineActivity(
                              routineId,
                              DateFormat('yyyy-MM-dd').format(date),
                              innerNotify: true,
                            );
                          },
                        ),

                        Space.h20,

                        Builder(
                          builder: (context) {
                            if (provider.innerLoading) {
                              return Center(child: CircularProgressIndicator());
                            }

                            int length =
                                (provider
                                        .activityModel
                                        ?.activityContent
                                        .length ??
                                    0);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Space.h20,
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: length,
                                          itemBuilder: (context, index) {
                                            int activeIndex = 0;

                                            return Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                if (index < length - 1)
                                                  Container(
                                                    height:
                                                        index == length
                                                            ? 0
                                                            : 108,
                                                    width: 4,

                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: HexColor(
                                                            '#E9CDFF',
                                                          ).withValues(
                                                            alpha: 0.7,
                                                          ),
                                                          spreadRadius: 1,
                                                          blurRadius: 12,
                                                          offset: Offset(0, 1),
                                                        ),
                                                      ],
                                                      color:
                                                          activeIndex > index
                                                              ? null
                                                              : HexColor(
                                                                '#E9CDFF',
                                                              ),
                                                      gradient:
                                                          activeIndex <= index
                                                              ? null
                                                              : LinearGradient(
                                                                begin:
                                                                    Alignment
                                                                        .topCenter,
                                                                end:
                                                                    Alignment
                                                                        .bottomCenter,

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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100,
                                                          ),
                                                      color:
                                                          activeIndex > index
                                                              ? null
                                                              : HexColor(
                                                                '#E9CDFF',
                                                              ),
                                                      gradient:
                                                          activeIndex < index
                                                              ? null
                                                              : LinearGradient(
                                                                begin:
                                                                    Alignment
                                                                        .topCenter,
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
                                      itemCount: length,
                                      separatorBuilder:
                                          (context, index) => Space.h16,
                                      itemBuilder: (context, index) {
                                        final activity =
                                            provider
                                                .activityModel!
                                                .activityContent[index];
                                        return RoutineLevelContainer(
                                          isCompleted: index == 0,
                                          currentLevel: index == 0,
                                          index: index,
                                          activityContentModel: activity,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
