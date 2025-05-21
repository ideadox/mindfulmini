import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../../injection/injection.dart';
import '../../play visuals/screen/play_visuals.dart';

class ShortStories extends StatelessWidget {
  const ShortStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Short Stories',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            'Quick Yoga sequence for kids to slow down',
            style: TextStyle(color: Colors.black45),
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 330,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                sl<GoRouter>().pushNamed(PlayVisuals.routeName);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 268,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.dummy.meditationCard.path),
                      ),
                    ),
                  ),
                  Space.h16,
                  Row(
                    children: [
                      Space.w12,
                      Container(
                        height: 24,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.grey45),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(Assets.icons.timeCircle),
                            Text(
                              '5 minutes',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
