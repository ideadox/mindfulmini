import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';

class FiveStepProgressBar extends StatelessWidget {
  final double percentComplete;
  final double height;

  const FiveStepProgressBar({
    super.key,
    required this.percentComplete,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    int totalSteps = 5;
    double stepPercent = 100 / totalSteps;
    int filledSteps = (percentComplete / stepPercent).floor();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps, (index) {
        bool isFilled = index < filledSteps;

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1),
            height: height,
            decoration: BoxDecoration(
              gradient: !isFilled ? null : AppColors.primaryGradient,
              color: isFilled ? null : Colors.grey.shade400,
              borderRadius: BorderRadius.horizontal(
                left: index == 0 ? Radius.circular(30) : Radius.zero,
                right:
                    index == totalSteps - 1 ? Radius.circular(30) : Radius.zero,
              ),
            ),
          ),
        );
      }),
    );
  }
}
