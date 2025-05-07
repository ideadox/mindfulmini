import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/common/widgets/common_close_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/onbaord/providers/onboards_provider.dart';
import 'package:provider/provider.dart';

class FellingToday extends StatelessWidget {
  static String routeName = 'feeling-today';
  static String routePath = '/feeling-today';
  const FellingToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardsProvider>(
      builder: (context, provider, _) {
        return GradientScaffold(
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonCloseButton(
                      onPressed: () {
                        provider.onSkipFeeling();
                      },
                    ),
                  ],
                ),
                Text(
                  'How are you feeling today?',
                  style: AppTextTheme.titleTextTheme(context).titleLarge,
                ),
                SizedBox(height: 10),
                Text(
                  "Select your child's age to personalize their mindfulness journey",
                  style: AppTextTheme.titleTextTheme(context).bodyMedium,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0, // spacing between columns
                    ),
                    itemCount: provider.feelList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          provider.onChangeFeeling(
                            provider.feelList[index]['name'] ?? '',
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    provider.feeling == null ||
                                            provider.feeling !=
                                                provider.feelList[index]['name']
                                        ? null
                                        : Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                provider.feelList[index]['img'] ?? '',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              provider.feelList[index]['name'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                GradientButton(
                  onPressed:
                      provider.feeling == null
                          ? null
                          : () {
                            provider.onFeelingSave();
                          },
                  child: Center(
                    child: Text(
                      'Select',
                      style:
                          AppTextTheme.mainButtonTextStyle(context).titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
