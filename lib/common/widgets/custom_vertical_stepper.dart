import 'package:flutter/material.dart';

class CustomVerticalStepper extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double width;
  final double spacing;
  final double stepHeight;

  const CustomVerticalStepper({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.width = 10,
    this.spacing = 8,
    this.stepHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Container(
          margin: EdgeInsets.symmetric(vertical: spacing / 2),
          width: width,
          height: stepHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: index == 0 ? const Radius.circular(20) : Radius.zero,
              bottom:
                  index == totalSteps - 1
                      ? const Radius.circular(20)
                      : Radius.zero,
            ),
            gradient:
                isActive
                    ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF95D11), Color(0xFFFCCB6C)],
                    )
                    : null,
            color: isActive ? null : const Color(0xFFEAEAEA),
          ),
        );
      }),
    );
  }
}
