import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_level_percent_indicator.dart';

class RoutineCard extends StatelessWidget {
  final String icon;
  final String title, subtitle;
  final bool isCompleted;
  const RoutineCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, 4),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(icon),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        trailing: isCompleted ? CustomLevelPercentIndicator(percent: 1) : null,
      ),
    );
  }
}
