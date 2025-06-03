import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';

import '../../../../core/app_spacing.dart';
import '../week_widgets/gradint_circular_indicator.dart';

class TodayHorizCalender extends StatelessWidget {
  const TodayHorizCalender({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday));
    return SizedBox(
      height: 130,

      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (context, index) {
          return Space.w4;
        },
        itemBuilder: (context, index) {
          DateTime date = startOfWeek.add(Duration(days: index));
          DateTime today = DateTime.now();
          bool isToday =
              date.day == today.day &&
              date.month == today.month &&
              date.year == today.year;

          return Container(
            width: width / 9,
            alignment: Alignment.center,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.E().format(date),
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Space.h16,
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isToday)
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(100),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.06),
                            ),
                          ),
                        ),
                      GradientCircularIndicator(
                        percent: 0.75,
                        radius: 20,
                        lineWidth: 3,
                        gradientColors:
                            AppColors.primaryGradientColors.reversed.toList(),
                        centerText: date.day.toString(),
                        isslected: isToday,
                      ),
                      if (!isToday)
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(100),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
