import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';

class AnimatedGradientProgressBar extends StatelessWidget {
  final double progressPercent;

  const AnimatedGradientProgressBar({super.key, required this.progressPercent});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: 4,
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: size.width * progressPercent.clamp(0.0, 1.0),
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: AppColors.primaryGradientColors,
            ),
          ),
        ),
      ),
    );
  }
}
