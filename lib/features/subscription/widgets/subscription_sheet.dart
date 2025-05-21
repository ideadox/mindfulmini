import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/common_close_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/subscription/widgets/plan_card.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/widgets/common_check_icon.dart';

class SubscriptionSheet extends StatelessWidget {
  const SubscriptionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 90),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.3)),
              ),
              Image.asset(Assets.images.subscriptionMain.path),
              Image.asset(Assets.images.whiteShadePng.path),
              SizedBox(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          'Unlock Mindful Minis',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Space.h20,
                        TextRow(text: 'Limited content to explore'),
                        Space.h12,
                        TextRow(
                            text:
                                'Basic Yoga Practices for building strength, flexibility, and mindfulness'),
                        Space.h12,
                        TextRow(
                            text:
                                'Access to selected Mindful-minis moral stories'),
                        Space.h12,
                        TextRow(text: 'Limited music tracks to chill out'),
                        Space.h12,
                        TextRow(
                            text:
                                "Basic mood tracking to help recognize kids' emotional patterns and triggers"),
                        Space.h20,
                        Space.h20,
                        PlanCard(
                          isSelected: true,
                          type: 'Monthly',
                          priceText: '49.99/ Month',
                        ),
                        Space.h4,
                        PlanCard(
                          type: 'Annually',
                          priceText: '49.99/ Month',
                          saveCount: 'Save 59%',
                          breifText: 'Only 42 / Months',
                        ),
                        Space.h20,
                        GradientButton(
                            onPressed: () {},
                            child: Center(
                                child: Text(
                              'Start your 7-day Free Trails',
                              style: AppTextTheme.mainButtonTextStyle(context)
                                  .titleLarge,
                            )))
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  right: 20,
                  top: 20,
                  child: CommonCloseButton(
                    onPressed: () {
                      sl<GoRouter>().pop();
                    },
                    borderColor: AppColors.purple,
                  )),
            ],
          ),
        ),
        Positioned(
            top: 0, child: SvgPicture.asset(Assets.images.subscriptionTop))
      ],
    );
  }
}

class TextRow extends StatelessWidget {
  final String text;
  const TextRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonCheckIcon(),
        Space.w12,
        Expanded(
            child: Text(
          text,
          style: TextStyle(
              color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w300),
        ))
      ],
    );
  }
}
