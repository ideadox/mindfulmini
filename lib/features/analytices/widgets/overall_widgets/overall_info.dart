import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/overall_widgets/overall_chart.dart';

class OverallInfo extends StatelessWidget {
  const OverallInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Fully Completed days: ',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text('12/30', style: TextStyle(fontSize: 12)),
            Spacer(),
            Text(
              'Spent: ',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text('13h 30 min', style: TextStyle(fontSize: 12)),
          ],
        ),
        Space.h32,

        OverallChart(
          value: 80,
          gradientColors: AppColors.primaryGradientColors,
          strokeWidth: 22,
        ),
      ],
    );
  }
}
