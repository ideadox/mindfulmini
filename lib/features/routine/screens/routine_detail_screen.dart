import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/custom_precentage_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/features/routine/providers/routine_activity_provider.dart';
import 'package:mindfulminis/features/routine/widgets/horizontal_week_calender.dart';
import 'package:mindfulminis/features/routine/widgets/routine_level_container.dart';
import 'package:mindfulminis/features/routine/widgets/routine_detail_shimmer.dart';
import 'package:provider/provider.dart';

import '../models/routine_model.dart';

class RoutineDetailScreen extends StatelessWidget {
  static String routeName = 'routine-detail-screen';
  static String routePath = '/routine-detail-screen/:routineId';
  final String routineId;

  /// Optional: pass the full RoutineModel for rich display data
  final RoutineModel? routineModel;

  const RoutineDetailScreen({
    super.key,
    required this.routineId,
    this.routineModel,
  });

  @override
  Widget build(BuildContext context) {
    // Derive display values from the model when available
    final timeOfDay = routineModel?.timeOfDay ?? '';
    final routineTitle =
        timeOfDay.isNotEmpty
            ? '${timeOfDay[0].toUpperCase()}${timeOfDay.substring(1)} Routine'
            : 'My Routine';
    final dailyMinutes = routineModel?.dailyDurationMinutes;
    final goalCount = routineModel?.goals.length;
    // Per-goal minutes (split daily time evenly across goals)
    final minutesPerGoal =
        (dailyMinutes != null && goalCount != null && goalCount > 0)
            ? (dailyMinutes / goalCount).round()
            : null;

    final profileId = Provider.of<ProfileProvider>(
      context,
      listen: false,
    ).userProfile?.id;

    // Use routine's startDate if today is before it, otherwise use today
    final now = DateTime.now();
    final initialDate =
        (routineModel != null && routineModel!.startDate.isAfter(now))
            ? routineModel!.startDate
            : now;

    return ChangeNotifierProvider(
      create:
          (context) => RoutineActivityProvider(
            routineId,
            DateFormat('yyyy-MM-dd').format(initialDate),
            initialDate: initialDate,
          ),
      child: Scaffold(
        body: Consumer<RoutineActivityProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const RoutineDetailShimmer();
            }

            final hasGoals =
                provider.activityModel != null &&
                provider.activityModel!.goals.isNotEmpty;

            return Column(
              children: [
                // ── Header (always visible) ──
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
                              routineTitle,
                              style: const TextStyle(
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
                      CustomPercentageIndicator(
                        percent:
                            hasGoals
                                ? provider.activityModel!.averageProgress
                                        .toDouble() /
                                    100
                                : 0,
                      ),
                    ],
                  ),
                ),

                // ── Calendar + Content (always visible) ──
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
                              return const RoutineDetailShimmer(
                                showHeader: false,
                              );
                            }

                            if (!hasGoals) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      Space.h16,
                                      Text(
                                        'No activities for this date',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Space.h8,
                                      Text(
                                        'Try selecting a different date',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            int length =
                                provider.activityModel!.goals.length;
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
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: length,
                                          itemBuilder: (context, index) {
                                            // Determine active index based on completion
                                            int activeIndex = 0;
                                            for (
                                              int i = 0;
                                              i <
                                                  provider
                                                      .activityModel!
                                                      .goals
                                                      .length;
                                              i++
                                            ) {
                                              if (provider
                                                      .activityModel!
                                                      .goals[i]
                                                      .progress >=
                                                  100) {
                                                activeIndex = i + 1;
                                              }
                                            }

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
                                                          offset:
                                                              const Offset(
                                                                0,
                                                                1,
                                                              ),
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: length,
                                      separatorBuilder:
                                          (context, index) => Space.h16,
                                      itemBuilder: (context, index) {
                                        final activity =
                                            provider
                                                .activityModel!
                                                .goals[index];
                                        final isGoalCompleted =
                                            activity.progress >= 100;
                                        // Current level = first non-completed goal
                                        bool isCurrent = false;
                                        if (!isGoalCompleted) {
                                          final firstIncompleteIdx =
                                              provider.activityModel!.goals
                                                  .indexWhere(
                                                    (g) => g.progress < 100,
                                                  );
                                          isCurrent =
                                              firstIncompleteIdx == index;
                                        }

                                        return RoutineLevelContainer(
                                          isCompleted: isGoalCompleted,
                                          currentLevel: isCurrent,
                                          index: index,
                                          activityContentModel: activity,
                                          routineId: routineId,
                                          date: DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(provider.selectedDate),
                                          dailyDurationMinutes: minutesPerGoal,
                                          profileId: profileId,
                                          onReturn: () {
                                            // Re-fetch goals progress when
                                            // user returns from an activity
                                            provider.getRoutineActivity(
                                              routineId,
                                              DateFormat('yyyy-MM-dd').format(
                                                provider.selectedDate,
                                              ),
                                              innerNotify: true,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Space.h20,
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
