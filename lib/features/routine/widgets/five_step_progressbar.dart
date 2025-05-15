import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';

class FiveStepProgressBar extends StatelessWidget {
  final double percentComplete;

  const FiveStepProgressBar({super.key, required this.percentComplete});

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
            height: 10,
            decoration: BoxDecoration(
              gradient: !isFilled ? null : AppColors.primaryGradient,
              color: isFilled ? null : Colors.grey.shade300,
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
