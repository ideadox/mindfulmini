import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class DeepSleep extends StatelessWidget {
  const DeepSleep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Deep Sleep',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          trailing: Text('5 Minutes'),
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
              return Stack(
                children: [
                  Container(
                    width: 177,
                    height: 268,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Image.asset(
                      Assets.dummy.breathuing.path,
                      height: 268,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
