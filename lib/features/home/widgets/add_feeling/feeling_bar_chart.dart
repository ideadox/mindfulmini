import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';

import '../../../../gen/assets.gen.dart';

class FeelingBarChart extends StatelessWidget {
  const FeelingBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Feelings',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            'Daily records to identify and positively express feelings',
            style: AppTextTheme.bodyTextStyle(
              context,
            ).bodyMedium?.copyWith(fontSize: 12),
          ),
        ),
        WeeklyBarChart(
          data: [
            BarChartData(
              height: 90,
              day: 'Mon',
              date: '02',

              thumbAsset: Assets.icons.amazingEmoji,
            ),
            BarChartData(
              height: 120,
              day: 'Tue',
              date: '03',
              thumbAsset: Assets.icons.amazingEmoji,
            ),
            BarChartData(height: 0, day: 'Wed', date: '04'),
            BarChartData(height: 0, day: 'Thu', date: '05'),
            BarChartData(
              height: 100,
              day: 'Fri',
              date: '06',
              thumbAsset: Assets.icons.amazingEmoji,
            ),
            BarChartData(
              height: 60,
              day: 'Sat',
              date: '07',
              thumbAsset: Assets.icons.amazingEmoji,
            ),
            BarChartData(
              height: 80,
              day: 'Sun',
              date: '08',
              thumbAsset: Assets.icons.amazingEmoji,
            ),
          ],
        ),
      ],
    );
  }
}

class WeeklyBarChart extends StatelessWidget {
  final List<BarChartData> data;

  const WeeklyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return SizedBox(
      height: 245,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double chartWidth = constraints.maxWidth / 10;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  data.map((barData) {
                    bool isToday =
                        today.day.toString().padLeft(2, '0') == barData.date;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: chartWidth,
                          height: 180,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: AppColors.purple.withValues(alpha: 0.1),
                          ),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              if (barData.thumbAsset != null)
                                Container(
                                  height: 33,
                                  width: 33,
                                  padding: EdgeInsets.only(
                                    left: 2,
                                    right: 1,
                                    bottom: 2,
                                    top: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: SvgPicture.asset(barData.thumbAsset!),
                                ),
                              Container(
                                width: chartWidth,
                                height: barData.height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),

                        Text(
                          barData.day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isToday ? Colors.black : Colors.black54,
                          ),
                        ),
                        Space.h8,
                        Container(
                          height: 24,
                          width: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isToday ? null : HexColor('#B5A1F4'),
                            borderRadius: BorderRadius.circular(100),
                            gradient:
                                !isToday
                                    ? null
                                    : LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        HexColor('#DCB8FF'),
                                        HexColor(
                                          '#DCB8FF',
                                        ).withValues(alpha: 0.5),
                                      ],
                                    ),
                          ),
                          child: Text(
                            barData.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: isToday ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class BarChartData {
  final double height;
  final String day;
  final String date;

  final String? thumbAsset;

  BarChartData({
    required this.height,
    required this.day,
    required this.date,

    this.thumbAsset,
  });
}
