import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/time_widget.dart';
import 'package:mindfulminis/common/widgets/views_widget.dart';

import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/breathing/providers/breathing_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class BreathingCategory extends StatelessWidget {
  const BreathingCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Consumer<BreathingProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Category',
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  'Breathing routines to support kids throughout the day',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ),
              Space.h8,
              Container(
                height: 48,

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        HexColor('#DCB8FF'),
                        HexColor('#DCB8FF').withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(300),
                  ),
                  tabs: [
                    Tab(text: 'Morning'),
                    Tab(text: 'Afternoon'),
                    Tab(text: 'Evening'),
                  ],
                ),
              ),
              CategoryWiseList(),
            ],
          );
        },
      ),
    );
  }
}

class CategoryWiseList extends StatelessWidget {
  const CategoryWiseList({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 14),
      shrinkWrap: true,
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 268,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              height: 268,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.dummy.meditationCard.path),
                ),
              ),
            ),

            Positioned(right: 10, bottom: 10, child: TimeWidget(totalTime: 5)),

            Positioned(right: 10, top: 10, child: ViewsWidget(totalViews: 122)),
          ],
        );
      },
    );
  }
}
