import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/meditation/providers/meditation_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MeditationProvider>(
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
                'Quick Yoga sequence for kids to slow down',
                style: TextStyle(color: Colors.black45),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  provider.tabs.map((tab) {
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),

                              onTap: () {
                                provider.changeIndex(tab);
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),

                                  gradient:
                                      provider.currentTab != tab
                                          ? null
                                          : LinearGradient(
                                            colors:
                                                AppColors
                                                    .secondaryGradientColors,
                                          ),
                                ),
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color:
                                        provider.currentTab == tab
                                            ? AppColors.purple.withValues(
                                              alpha: 0.5,
                                            )
                                            : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    tab,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          provider.currentTab == tab
                                              ? Colors.black
                                              : Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Space.w12,
                        ],
                      ),
                    );
                  }).toList(),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 330,

                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return Column(
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
                );
              },
            ),
          ],
        );
      },
    );
  }
}
