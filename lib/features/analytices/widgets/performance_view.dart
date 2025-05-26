import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class PerformanceView extends StatelessWidget {
  const PerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance View',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        Space.h16,
        Row(
          children: [
            // Expanded(child: child),
            Space.h16,
          ],
        ),
        Space.h16,
        Row(children: [Space.h16]),
      ],
    );
  }
}
