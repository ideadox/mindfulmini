import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';

import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/widgets/time_widget.dart';
import '../../../common/widgets/views_widget.dart';
import '../../play visuals/screen/play_visuals.dart';

class BreathingSuggestion extends StatelessWidget {
  const BreathingSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Suggested For You',
            style: AppTextTheme.titleTextTheme(
              context,
            ).titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text(
            'Short breathing exercises to help kids slow down and feel peaceful',
            style: TextStyle(color: Colors.black45, fontSize: 12),
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
                  sl<GoRouter>().pushNamed(PlayVisuals.routeName);
                },
                child: Stack(
                  children: [
                    Container(
                      width: 216,
                      height: 268,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        Assets.dummy.meditationSuggestionCard.path,
                      ),
                    ),

                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: TimeWidget(totalTime: 5),
                    ),

                    Positioned(
                      right: 10,
                      top: 10,
                      child: ViewsWidget(totalViews: 122),
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
