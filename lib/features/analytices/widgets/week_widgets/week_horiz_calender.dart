import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';

import '../../../../core/app_spacing.dart';
import 'gradint_circular_indicator.dart';

class WeekHorizCalender extends StatelessWidget {
  const WeekHorizCalender({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double availableSpace = width - 25;
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
                  child: GradientCircularIndicator(
                    percent: 0.75,
                    radius: 20,
                    lineWidth: 3,
                    gradientColors:
                        AppColors.primaryGradientColors.reversed.toList(),
                    centerText: "75",
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
