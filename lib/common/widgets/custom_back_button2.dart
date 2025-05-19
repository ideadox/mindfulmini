import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/injection/injection.dart';

class CustomBackButton2 extends StatelessWidget {
  const CustomBackButton2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),

        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 0.5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          sl<GoRouter>().pop();
        },
        icon: Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}
