import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/video_progress_bar.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class RecentCollection extends StatelessWidget {
  const RecentCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Recently  Watched',
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
              return Column(
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

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SvgPicture.asset(Assets.dummy.frame2043683273),
                        ),
                      ),

                      Container(
                        width: 296,
                        height: 268,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.5),

                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 10,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.icons.timer,
                                  height: 16,
                                  width: 16,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Space.w4,
                                Text(
                                  '5 min left',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Space.h8,
                            VideoProgressBar(progress: 0.3),
                            Space.h8,
                            SizedBox(
                              height: 29,
                              width: 76,
                              child: GradientButton(
                                hasShadow: false,
                                onPressed: () {},
                                child: Center(
                                  child: Text(
                                    'Resume',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text('6 Poses', style: TextStyle(color: Colors.black45)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
