import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class StarterDeck extends StatelessWidget {
  const StarterDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Mindfulness yoga starter Deck',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            'Welcome to your little yogis first flow',
            style: AppTextTheme.bodyTextStyle(
              context,
            ).bodySmall?.copyWith(color: AppColors.grey45),
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
              return Stack(
                children: [
                  Container(
                    width: 216,
                    height: 268,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Image.asset(
                      Assets.dummy.starterDeck.path,
                      height: 268,
                    ),
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
