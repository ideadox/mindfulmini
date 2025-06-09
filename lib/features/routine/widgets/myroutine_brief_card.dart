import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/routine/screens/my_routine_screen.dart';
import 'package:mindfulminis/features/routine/widgets/five_step_progressbar.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class MyroutineBriefCard extends StatelessWidget {
  final bool formHome;
  const MyroutineBriefCard({super.key, this.formHome = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [HexColor('#CDCEFF'), HexColor('#FCFAFF')],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Image.asset(Assets.vectors.myroutineRightPng.path),
          ),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(Assets.vectors.myroutineCenter),
          ),

          Positioned(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 12,
                top: 15,
                bottom: 15,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.icons.sunIcon),
                      Space.w8,
                      Text('Morning Routine'),
                    ],
                  ),
                  Space.h12,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '7-Day Kickstart',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: HexColor('#47454D'),
                              ),
                            ),
                            Space.h16,
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppColors.purple.withOpacity(0.4),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomGradientText(text: '3'),
                                      Space.w4,
                                      Text('Tasks'),
                                      Space.w4,
                                      SizedBox(
                                        height: 18,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      CustomGradientText(text: '40'),
                                      Space.w4,
                                      Text('Min'),
                                    ],
                                  ),
                                ),
                                Space.w8,
                                Text(
                                  "Day 1",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Builder(
                          builder: (context) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),

                                gradient: AppColors.primaryGradient,
                              ),
                              child: Container(
                                height: 42,

                                alignment: Alignment.center,
                                margin: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Space.h16,
                  Row(
                    children: [
                      Expanded(child: FiveStepProgressBar(percentComplete: 20)),
                      Space.w8,
                      Text('10%'),
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
