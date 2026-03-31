import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class ViewsWidget extends StatelessWidget {
  final int totalViews;
  const ViewsWidget({super.key, required this.totalViews});

  @override
  Widget build(BuildContext context) {
    final gray = const Color(0xFF30303D).withValues(alpha: 0.8);
    return Container(
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.visibility, size: 16, color: gray),
            Space.w4,
            Text(
              AppFormate.formatViews(totalViews),
              style: TextStyle(fontSize: 12, color: gray, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
