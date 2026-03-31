import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class TimeWidget extends StatelessWidget {
  final int totalTime;
  const TimeWidget({super.key, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF30303D).withValues(alpha: 0.8);
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, size: 16, color: color),
          Space.w4,
          Text(
            '${totalTime.toString()}m',
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
