import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/models/week_anayl_design.dart';
import 'package:mindfulminis/features/analytices/widgets/week_widgets/week_anayl_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class WeekAnayl extends StatelessWidget {
  const WeekAnayl({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, WeekAnaylDesign> designMap = {
      'Morning Routine': WeekAnaylDesign(
        gradientColors: [
          HexColor('#C0D5FF').withValues(alpha: 0.5),
          HexColor('#DDE4EA'),
        ],
        titleColors: [HexColor('#2D5BFF'), HexColor('#2D5BFF')],
      ),
      'Afternoon Routine': WeekAnaylDesign(
        gradientColors: [
          HexColor('#FFE6B3').withValues(alpha: 0.5),
          HexColor('#FFFFFF'),
        ],
        titleColors: [HexColor('#F95D11'), HexColor('#FCCB6C')],
      ),
      'Evening Routine': WeekAnaylDesign(
        gradientColors: [
          HexColor('#FFDACF').withValues(alpha: 0.5),
          HexColor('#EBC4FF').withValues(alpha: 0.2),
        ],
        titleColors: [HexColor('#9F33F4'), HexColor('#D23BD5')],
      ),
      'Dreamland Serenity': WeekAnaylDesign(
        gradientColors: [
          HexColor('#BEA6FF').withValues(alpha: 0.5),
          HexColor('#FFFFFF'),
        ],
        titleColors: [HexColor('#F6F6F6'), HexColor('#F6F6F6')],
      ),
    };

    List<WeekAnaylModel> _items = [
      WeekAnaylModel(title: 'Morning Routine', icon: Assets.icons.sunIcon),
      WeekAnaylModel(
        title: 'Afternoon Routine',
        icon: Assets.icons.fullSunGradOrnage,
      ),
      WeekAnaylModel(title: 'Evening Routine', icon: Assets.icons.sunDimIcon),
      WeekAnaylModel(title: 'Dreamland Serenity', icon: Assets.icons.moonIcon),
    ];
    return ListView.separated(
      padding: EdgeInsets.all(12),
      itemCount: _items.length,
      separatorBuilder: (context, index) => SizedBox(height: 20),
      itemBuilder: (context, index) {
        final item = _items[index];
        return WeekAnaylCard(
          type: item.title,
          icon: item.icon,
          design: designMap[item.title]!,
        );
      },
    );
  }
}

class WeekAnaylModel {
  final String title;
  final String icon;

  WeekAnaylModel({required this.title, required this.icon});
}
