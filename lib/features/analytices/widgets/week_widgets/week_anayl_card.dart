import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import 'week_horiz_calender.dart';

class WeekAnaylCard extends StatelessWidget {
  final String type, icon;
  final List<Color> gradientColors;
  const WeekAnaylCard({
    super.key,
    required this.type,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(Assets.vectors.anaylayticCardBackgroud.path),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(icon),
                    Space.w8,
                    CustomGradientText(text: type, isBold: true, fontSize: 12),
                    Spacer(),
                    Text('Activity', style: TextStyle(color: Colors.black54)),
                    Space.w8,
                    Text('5', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                WeekHorizCalender(),
                Row(
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: HexColor('#CE89FF').withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(Icons.calendar_today, size: 20),
                          ),
                          Space.w12,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '30 Days',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Space.h4,
                              Text(
                                'Spend 1h 13min',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Completion rate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Space.h8,
                        CustomGradientText(text: '84%'),
                      ],
                    ),
                  ],
                ),
                Space.h8,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
