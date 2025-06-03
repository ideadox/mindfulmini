import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/today_widgets/today_anayl_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class TodayAnayl extends StatelessWidget {
  const TodayAnayl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: -300,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                Assets.vectors.todayAnaylBg.path,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TodayAnaylCard(),
                  Space.h20,
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  Space.h20,
                  TodayAnaylCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
