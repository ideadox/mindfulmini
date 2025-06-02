import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/today_widgets/today_anayl_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class TodayAnayl extends StatelessWidget {
  const TodayAnayl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   fit: BoxFit.cover,
        //   alignment: Alignment.bottomCenter,
        //   image: AssetImage(Assets.vectors.todayAnaylBg.path),
        // ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: -300,
            child: Image.asset(
              Assets.vectors.todayAnaylBg.path,
              fit: BoxFit.fill,
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
