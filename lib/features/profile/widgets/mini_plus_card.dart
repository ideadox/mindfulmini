import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class MiniPlusCard extends StatelessWidget {
  const MiniPlusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),

        child: Stack(
          children: [
            Container(
              // margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(25),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Unlock MindfulMinis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Space.h12,
                  Text(
                    textAlign: TextAlign.center,
                    'Unlock Mindfulminis to access unlimited exclusive content. 7 days free trial.\nCancel anytime',
                    style: AppTextTheme.bodyTextStyle(context).bodyMedium,
                  ),
                  Space.h20,

                  SizedBox(
                    width: 145,
                    height: 45,
                    child: GradientButton(
                      onPressed: () {},
                      child: Center(
                        child: Text(
                          "Unlock Now",
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

            Positioned(
              right: 0,
              top: 0,
              child: Image.asset(Assets.profileIcons.topRightPng.path),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: SvgPicture.asset(Assets.profileIcons.bottomRight),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(Assets.profileIcons.bottomLeftPng.path),
            ),
            Positioned(
              left: -20,
              bottom: 0,
              child: SvgPicture.asset(Assets.profileIcons.bottom),
            ),
          ],
        ),
      ),
    );
  }
}
