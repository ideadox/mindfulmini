import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/activity/widgets/activity_home_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class MiniBodyScanWidget extends StatelessWidget {
  const MiniBodyScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Mini Body Scan',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            'Welcome to your little yogis first flow',
            style: AppTextTheme.bodyTextStyle(
              context,
            ).bodyMedium?.copyWith(fontSize: 12),
          ),
        ),
        Space.h12,
        SizedBox(
          height: height * 0.4,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) {
              return Space.w16;
            },
            itemBuilder: (context, index) {
              return SizedBox(
                height: double.infinity,
                width: width * 0.6,
                child: ActivityHomeCard(image: Assets.dummy.scanActivity.path),
              );
            },
          ),
        ),
      ],
    );
  }
}
