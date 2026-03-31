import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../../../core/app_spacing.dart';
import '../../../../core/app_text_theme.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/services/remote_config_service.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';

class YogaPicks extends StatelessWidget {
  const YogaPicks({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            strings.yoga('picks.title', fallback: 'Yoga Picks Just for You'),
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
                  // TODO: Replace with actual yoga ID when available
                  sl<GoRouter>().pushNamed(
                    PlayVisuals.routeName,
                    pathParameters: {'id': 'placeholder-id'},
                  );
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

                    Text(
                      strings.yoga('picks.poses_suffix', fallback: '6 Poses'),
                      style: TextStyle(color: Colors.black45),
                    ),
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
