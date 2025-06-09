import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import '../../../common/widgets/time_widget.dart';
import '../../../common/widgets/views_widget.dart';
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
            'Short and soothing Stories for little minds',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 268,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                sl<GoRouter>().pushNamed(PlayVisuals.routeName);
              },
              child: Stack(
                children: [
                  Container(
                    height: 268,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.dummy.meditationCard.path),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: TimeWidget(totalTime: 5),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: ViewsWidget(totalViews: 458),
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
