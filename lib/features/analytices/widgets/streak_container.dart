import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class StreakContainer extends StatelessWidget {
  final String title;
  final String icon;
  final String days;
  const StreakContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Space.w8,
              SvgPicture.asset(icon),
              Space.w12,
              Text(
                days,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Space.h8,
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
