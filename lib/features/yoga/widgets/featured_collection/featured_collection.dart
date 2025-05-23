import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/yoga/screens/yoga_list.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class FeaturedCollection extends StatelessWidget {
  const FeaturedCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Featured Collection',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
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
              return InkWell(
                onTap: () {
                  sl<GoRouter>().pushNamed(YogaList.routeName);
                },
                child: Stack(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
