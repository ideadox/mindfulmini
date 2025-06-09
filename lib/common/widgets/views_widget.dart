import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class ViewsWidget extends StatelessWidget {
  final int totalViews;
  const ViewsWidget({super.key, required this.totalViews});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,

      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.visibility, size: 18),

            Space.w4,
            Text(AppFormate.formatViews(248), style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
