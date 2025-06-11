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
        linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HexColor('#E5E5F9'),
            HexColor('#EAECFB'),
            HexColor('#ECEEFB'),
          ],
        ),
      ),
      'Afternoon Routine': WeekAnaylDesign(
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor('#FEFFCD').withValues(alpha: 0.7),

            HexColor('#E2C7FF').withValues(alpha: 0.6),
          ],
        ),
      ),
      'Evening Routine': WeekAnaylDesign(
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor('#FFB888').withValues(alpha: 0.5),
            // HexColor('#FFB888').withValues(alpha: 0.3),
            HexColor('#E2C7FF').withValues(alpha: 0.6),
          ],
        ),
      ),
      'Dreamland Serenity': WeekAnaylDesign(
        linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HexColor('#AC88FF').withValues(alpha: 0.4),
            HexColor('#E2C7FF').withValues(alpha: 0.4),
          ],
        ),
      ),
    };

    List<WeekAnaylModel> _items = [
      WeekAnaylModel(title: 'Morning Routine', icon: Assets.icons.sunIcon),
      WeekAnaylModel(
        title: 'Afternoon Routine',
        icon: Assets.icons.fullSunIcon,
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
