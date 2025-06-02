import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/overall_widgets/overall_info.dart';

import '../../../../common/widgets/custom_gradient_text.dart';
import '../../../../gen/assets.gen.dart';
import 'overall_build_routine_card.dart';
import 'overall_calender_view.dart';

class OverallAnaylCard extends StatelessWidget {
  const OverallAnaylCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.icons.sunDimIcon),
            Space.w8,
            CustomGradientText(
              text: 'Morning Routine',
              isBold: true,
              fontSize: 12,
            ),
          ],
        ),
        Space.h12,
        SizedBox(height: 200),
        OverallInfo(),
        Space.h20,

        OverallBuildRoutineCard(),
        Space.h20,

        OverallCalenderView(),
        Space.h20,
      ],
    );
  }
}
