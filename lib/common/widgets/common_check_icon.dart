import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';

class CommonCheckIcon extends StatelessWidget {
  const CommonCheckIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: AppColors.primaryGradient),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
