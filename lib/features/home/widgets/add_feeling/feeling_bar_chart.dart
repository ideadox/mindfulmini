
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../gen/assets.gen.dart';

class FeelingBarChart extends StatefulWidget {
  const FeelingBarChart({super.key});

  @override
  State<FeelingBarChart> createState() => _FeelingBarChartState();
}

class _FeelingBarChartState extends State<FeelingBarChart> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('bar'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.22 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Feelings',
              style: AppTextTheme.titleTextTheme(context).titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'Daily records to identify and positively express feelings',
              style: AppTextTheme.bodyTextStyle(
                context,
              ).bodyMedium?.copyWith(fontSize: 12),
            ),
          ),
          if (!_isVisible)
            WeeklyBarChart(
              data: [
                BarChartData(
                  height: 0,
                  day: 'Mon',
                  date: '02',

                  thumbAsset: Assets.icons.amazingEmoji,
                ),
                BarChartData(
                  height: 0,
                  day: 'Tue',
                  date: '03',
                  thumbAsset: Assets.icons.amazingEmoji,
                ),
                BarChartData(height: 0, day: 'Wed', date: '04'),
                BarChartData(height: 0, day: 'Thu', date: '05'),
                BarChartData(
                  height: 0,
                  day: 'Fri',
                  date: '06',
                  thumbAsset: Assets.icons.amazingEmoji,
                ),
                BarChartData(
                  height: 0,
                  day: 'Sat',
                  date: '07',
                  thumbAsset: Assets.icons.amazingEmoji,
                ),
                BarChartData(
                  height: 0,
                  day: 'Sun',
                  date: '08',
                  thumbAsset: Assets.icons.amazingEmoji,
                ),
              ],
            ),
          if (_isVisible)
            WeeklyBarChart(
              data: [
                BarChartData(
                  height: 30,
                  day: 'Mon',
                  date: '02',

                  thumbAsset: Assets.icons.amazingEmoji,
                ),
                BarChartData(
                  height: 50,
                  day: 'Tue',
                  date: '03',
                  thumbAsset: Assets.icons.amazingEmoji,
                ),
                BarChartData(height: 0, day: 'Wed', date: '04'),
                BarChartData(height: 0, day: 'Thu', date: '05'),
                BarChartData(
                  height: 70,
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
                  height: 100,
                  day: 'Sun',
                  date: '08',
                  thumbAsset: Assets.icons.amazingEmoji,
                ),
              ],
            ),
        ],
      ),
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
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 0,
                                  end:
                                      (barData.height.clamp(0, 100) / 100) *
                                      180,
                                ),
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeOutCubic,
                                builder: (context, animatedValue, child) {
                                  return Container(
                                    width: chartWidth,
                                    height: animatedValue,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          AppColors.primary.withValues(
                                            alpha: 0.05,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                        Space.h4,
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
