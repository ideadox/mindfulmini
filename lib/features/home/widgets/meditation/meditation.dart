import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class MeditationWidget extends StatelessWidget {
  const MeditationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Meditation',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            'Quick Meditation for Kids to Calm Down.',
            style: AppTextTheme.bodyTextStyle(
              context,
            ).bodyMedium?.copyWith(fontSize: 12),
          ),
        ),
        SizedBox(
          height: 268,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) {
              return Space.w16;
            },
            itemBuilder: (context, index) {
              return Container(
                width: 177,
                height: 268,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Image.asset(Assets.dummy.medit.path, height: 268),
              );
            },
          ),
        ),
      ],
    );
  }
}
