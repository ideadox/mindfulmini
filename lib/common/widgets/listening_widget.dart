import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../core/app_colors.dart';

class ListeningWidget extends StatelessWidget {
  const ListeningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RippleAnimation(
      color: AppColors.primary,
      delay: const Duration(milliseconds: 300),
      repeat: true,
      minRadius: 10,
      maxRadius: 20,
      ripplesCount: 3,
      duration: const Duration(milliseconds: 6 * 300),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.primary,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HexColor('#6E40F9'),
              HexColor('#A569FB'),
              HexColor('#CE89FF'),
            ],
          ),
        ),
        child: JumpingDots(
          color: Colors.white,
          radius: 5,
          numberOfDots: 3,
          delay: 2,
          animationDuration: Duration(milliseconds: 400),
        ),
      ),
    );
  }
}
