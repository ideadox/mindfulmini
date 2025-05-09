import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/journal/widgets/custom_month_calender.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 515,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        Assets.images.journalTopBackground.path,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: kToolbarHeight,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white54,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(Assets.icons.morningIcon),
                        Space.w12,

                        Text('Good Morning', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  child: Column(
                    children: [
                      Text(
                        'Gratitude Journaling',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.titleTextTheme(
                          context,
                        ).titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Space.h8,
                      Text(
                        'A Daily Practice of Thankfulness',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bodyTextStyle(
                          context,
                        ).bodyMedium?.copyWith(fontSize: 14),
                      ),
                      Space.h4,
                      SizedBox(
                        width: 170,
                        height: 48,
                        child: GradientButton(
                          onPressed: () {},
                          child: Center(
                            child: Text(
                              'Start',
                              style:
                                  AppTextTheme.mainButtonTextStyle(
                                    context,
                                  ).titleLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            CustomMonthCalender(),
            SizedBox(height: kToolbarHeight + 40),
          ],
        ),
      ),
    );
  }
}
