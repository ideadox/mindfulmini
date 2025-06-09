import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../../../core/app_spacing.dart';
import '../../../../core/app_text_theme.dart';
import '../../../../injection/injection.dart';
import '../../screens/yoga_list.dart';

class YogaPicks extends StatelessWidget {
  const YogaPicks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Yoga Picks Just for You',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 303,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
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

                    Text('6 Poses', style: TextStyle(color: Colors.black45)),
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
