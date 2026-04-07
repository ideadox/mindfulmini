import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/features/routine/models/routine_model.dart';
import 'package:mindfulminis/features/routine/widgets/five_step_progressbar.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class MyroutineBriefCard extends StatelessWidget {
  final RoutineModel routineModel;

  /// Today's average activity-completion progress (0–100).
  /// When provided, the card shows this instead of time-based progress.
  final int? activityProgress;

  const MyroutineBriefCard({
    super.key,
    required this.routineModel,
    this.activityProgress,
  });

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    final daysSinceStart = routineModel.dayNumberSinceStart();

    // Use activity-based progress when available, otherwise fall back to
    // time-based progress.
    final double percentComplete;
    if (activityProgress != null) {
      percentComplete = activityProgress!.clamp(0, 100).toDouble();
    } else {
      final totalDays = routineModel.durationDays;
      percentComplete =
          totalDays > 0
              ? ((daysSinceStart / totalDays) * 100).clamp(0, 100).toDouble()
              : 0.0;
    }
    final isExpired = daysSinceStart >= routineModel.durationDays;
    final isFirstDay = daysSinceStart == 0;
    final String ctaText;
    if (isExpired) {
      ctaText = strings.routine(
        'my_routine_brief.cta_extend',
        fallback: 'Extend',
      );
    } else if (percentComplete == 0) {
      ctaText =
          isFirstDay
              ? strings.routine(
                'my_routine_brief.cta_get_started',
                fallback: 'Get Started',
              )
              : strings.routine(
                'my_routine_brief.cta_start',
                fallback: 'Start',
              );
    } else if (percentComplete < 100) {
      ctaText = strings.routine(
        'my_routine_brief.cta_resume',
        fallback: 'Resume',
      );
    } else {
      ctaText = strings.routine('my_routine_brief.cta_start', fallback: 'Start');
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [HexColor('#CDCEFF'), HexColor('#FCFAFF')],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Image.asset(Assets.vectors.myroutineRightPng.path),
          ),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(Assets.vectors.myroutineCenter),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 12,
                top: 15,
                bottom: 15,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.icons.sunIcon),
                      Space.w8,
                      Text(
                        routineModel.timeOfDay.isNotEmpty
                            ? '${routineModel.timeOfDay[0].toUpperCase()}${routineModel.timeOfDay.substring(1)}'
                            : strings.routine(
                              'my_routine_brief.fallback_title',
                              fallback: 'Routine',
                            ),
                      ),
                    ],
                  ),
                  Space.h12,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${routineModel.durationDays}${strings.routine('my_routine_brief.days_suffix', fallback: '-Days')}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: HexColor('#47454D'),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${DateFormat('MMM d').format(routineModel.startDate)} – ${DateFormat('MMM d').format(routineModel.endDate)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (routineModel.wasExtended) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Extended from ${DateFormat('MMM d').format(routineModel.extendedDate!)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                            Space.h16,
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppColors.purple.withValues(alpha: 0.4),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomGradientText(
                                        text:
                                            routineModel.goals.length
                                                .toString(),
                                      ),
                                      Space.w4,
                                      Text(
                                        strings.routine(
                                          'my_routine_brief.tasks_label',
                                          fallback: 'Tasks',
                                        ),
                                      ),
                                      Space.w4,
                                      const SizedBox(
                                        height: 18,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      CustomGradientText(
                                        text:
                                            routineModel.dailyDurationMinutes
                                                .toString(),
                                      ),
                                      Space.w4,
                                      Text(
                                        strings.routine(
                                          'my_routine_brief.minutes_label',
                                          fallback: 'Min',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Space.w8,
                                Text(
                                  isExpired
                                      ? 'Expired'
                                      : '${strings.routine('my_routine_brief.day_prefix', fallback: 'Day')} $daysSinceStart',
                                  style:
                                      isExpired
                                          ? TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red.shade700,
                                          )
                                          : const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Container(
                            height: 42,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              ctaText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Space.h16,
                  Row(
                    children: [
                      Expanded(
                        child: FiveStepProgressBar(
                          percentComplete: percentComplete,
                        ),
                      ),
                      Space.w8,
                      Text('${percentComplete.round()}%'),
                      Expanded(child: Container()),
                    ],
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
