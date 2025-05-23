import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/streak_container.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class StreakRow extends StatelessWidget {
  const StreakRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StreakContainer(
            title: 'Current Streak',
            icon: Assets.profileIcons.currentStreak,
            days: '19 Days',
          ),
        ),
        Space.w12,
        Expanded(
          child: StreakContainer(
            title: 'Longest Streak',
            icon: Assets.profileIcons.longestStreak,
            days: '52 Days',
          ),
        ),
      ],
    );
  }
}
