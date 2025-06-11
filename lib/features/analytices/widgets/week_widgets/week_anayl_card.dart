import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../models/week_anayl_design.dart';
import 'week_horiz_calender.dart';

class WeekAnaylCard extends StatelessWidget {
  final String type, icon;
  final WeekAnaylDesign design;
  const WeekAnaylCard({
    super.key,
    required this.type,
    required this.icon,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
        gradient: design.linearGradient,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (type == 'Dreamland Serenity')
            Positioned(
              left: -180,
              top: 0,
              child: Image.asset(Assets.vectors.weekAnaylLayer2.path),
            ),

          if (type == 'Dreamland Serenity' || type == 'Evening Routine')
            Image.asset(Assets.vectors.weekAnaylLayer2.path),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(height: 20, width: 20, icon),
                    Space.w8,
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: AppColors.primaryGradientColors,
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

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
                        color: AppColors.primary.withValues(alpha: 0.1),
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
