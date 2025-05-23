import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class LessionContainer extends StatelessWidget {
  const LessionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.lightGreen.shade100.withValues(alpha: 0.8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: SvgPicture.asset(
          height: 35,
          width: 18,
          Assets.profileIcons.currentStreak,
        ),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Do a lesson every day this week to earn this '),
              TextSpan(
                text: 'Perfect Streak',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' flame!'),
            ],
          ),
        ),
      ),
    );
  }
}
