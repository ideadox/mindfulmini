import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GradientCircularIndicator extends StatelessWidget {
  final double percent;
  final double radius;
  final double lineWidth;
  final List<Color> gradientColors;
  final String centerText;

  const GradientCircularIndicator({
    super.key,
    required this.percent,
    required this.radius,
    required this.lineWidth,
    required this.gradientColors,
    required this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      percent: percent.clamp(0.0, 1.0),
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        centerText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      linearGradient: LinearGradient(colors: gradientColors),
    );
  }
}
