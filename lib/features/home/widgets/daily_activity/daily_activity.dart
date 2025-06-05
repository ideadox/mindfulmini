import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';

import '../../../../gen/assets.gen.dart';

class DailyActivityWidget extends StatelessWidget {
  const DailyActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Daily Activities',
          style: AppTextTheme.titleTextTheme(
            context,
          ).headlineLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        Space.h8,
        Text(
          textAlign: TextAlign.center,
          'Pick a card to begin your mindfulness adventure!',
          style: AppTextTheme.bodyTextStyle(context).bodyMedium,
        ),
        Space.h20,
        SizedBox(
          height: 268,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) {
              return Space.w16;
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width: 296,
                    height: 268,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: SvgPicture.asset(Assets.dummy.frame2043683273),
                  ),
                  // Positioned(bottom: 50, left: 16, child: TotalTimingWidget()),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
