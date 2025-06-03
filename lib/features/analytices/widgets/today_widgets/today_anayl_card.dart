import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/today_widgets/routine_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../../../common/widgets/custom_segemt_percent_indicator.dart';
import '../../models/routine_level_model.dart';
import 'today_horiz_calender.dart';

class TodayAnaylCard extends StatelessWidget {
  const TodayAnaylCard({super.key});

  @override
  Widget build(BuildContext context) {
    List<RoutineLevelModel> levelData = [
      RoutineLevelModel(
        icon: Assets.images.gratitueAvatar.path,
        title: 'Gratitude Journal',
        subtitle: '5min/5min',
        isCompleted: true,
      ),
      RoutineLevelModel(
        icon: Assets.images.affirmationAvatar.path,
        title: 'Affirmation',
        subtitle: '5min/5min',
        isCompleted: true,
      ),
      RoutineLevelModel(
        icon: Assets.images.meditationAvatar.path,
        title: 'Meditation',
        subtitle: '5min/5min',
        isCompleted: true,
      ),
      RoutineLevelModel(
        icon: Assets.images.breadthingAvatar.path,
        title: 'Breath',
        subtitle: '5min/5min',
        isCompleted: true,
      ),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        TodayHorizCalender(),
        Space.h20,

        CustomSegemtPercentIndicator(
          levels: [
            DurationLevel(
              invested: Duration(minutes: 12),
              total: Duration(minutes: 15),
              color: [
                HexColor('#6E40F9'),
                HexColor('#A569FB'),
                HexColor('#CE89FF'),
              ],
            ),

            DurationLevel(
              invested: Duration(minutes: 4),
              total: Duration(minutes: 5),
              color: [HexColor('#F7B25E'), HexColor('#FEDD8378')],
            ),
            DurationLevel(
              invested: Duration(minutes: 3),
              total: Duration(minutes: 5),
              color: [HexColor('#BA7DFF'), HexColor('#FF9DBA')],
            ),
            DurationLevel(
              invested: Duration(minutes: 10),
              total: Duration(minutes: 10),
              color: [HexColor('#D2F5E3'), HexColor('#64BD94')],
            ),
          ],
          child: Column(
            children: [
              Text(
                '25 Min',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                '30 min',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),

        Space.h40,
        ListView.separated(
          itemCount: levelData.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => Space.h12,
          itemBuilder: (context, index) {
            final item = levelData[index];
            return RoutineCard(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              isCompleted: item.isCompleted,
            );
          },
        ),
      ],
    );
  }
}
