import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
              gradientColors: [HexColor('#C0D5FF'), HexColor('#DDE4EA')],
            ),
            Space.h16,
            WeekAnaylCard(
              type: 'Afternoon Routine',
              icon: Assets.icons.fullSunIcon,
              gradientColors: [HexColor('#FFE6B3'), HexColor('#FFFFFF')],
            ),
            Space.h16,

            WeekAnaylCard(
              type: 'Afternoon Routine',
              icon: Assets.icons.fullSunIcon,
              gradientColors: [HexColor('#FFDACF'), HexColor('#EBC4FF')],
            ),
            Space.h16,

            WeekAnaylCard(
              type: 'Afternoon Routine',
              icon: Assets.icons.fullSunIcon,
              gradientColors: [HexColor('#BEA6FF'), HexColor('#FFFFFF')],
            ),
          ],
        ),
      ),
    );
  }
}
