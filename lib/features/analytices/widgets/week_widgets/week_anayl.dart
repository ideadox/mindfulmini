import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/week_widgets/week_anayl_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class WeekAnayl extends StatelessWidget {
  const WeekAnayl({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            WeekAnaylCard(
              type: 'Morning Routine',
              icon: Assets.icons.sunDimIcon,
            ),
            Space.h16,
            WeekAnaylCard(
              type: 'Morning Routine',
              icon: Assets.icons.sunDimIcon,
            ),
          ],
        ),
      ),
    );
  }
}
