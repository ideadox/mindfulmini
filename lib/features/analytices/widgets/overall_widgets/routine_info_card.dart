import 'package:flutter/material.dart';

class RoutineInfoCard extends StatelessWidget {
  final String icon;
  final String title, subtitle;
  final bool isCompleted;
  const RoutineInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }
}
