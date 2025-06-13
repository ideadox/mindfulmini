import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/core/app_spacing.dart';

import '../../../common/widgets/close_button_dailog.dart';
import '../../../common/widgets/gradient_button.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_theme.dart';
import '../../../gen/assets.gen.dart';

class Agelimitdailog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onCancel;
  const Agelimitdailog({
    super.key,
    required this.onContinue,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: height * 0.45,
          width: width * 0.9,
          margin: EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.bottomCenter,
              image: AssetImage(Assets.vectors.agelimitbgm.path),
            ),
            color: Colors.white,

            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            children: [
              InkWell(onTap: onCancel, child: CloseButtonDailog()),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Age Limit Reached",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: width * 0.6,

                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'This app is designed for children aged 3 to 10 years. Do you still want to continue?',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: width * 0.6,

                      child: GradientButton(
                        onPressed: onContinue,
                        child: Center(
                          child: Text(
                            'Yes, Continue',
                            style:
                                AppTextTheme.mainButtonTextStyle(
                                  context,
                                ).titleLarge,
                          ),
                        ),
                      ),
                    ),
                    Space.h12,

                    SizedBox(
                      width: width * 0.6,
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                foregroundColor: Colors.black,
                                side: BorderSide(color: AppColors.purple),
                              ),
                              onPressed: onCancel,
                              child: Text('No, Go Back'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          child: SvgPicture.asset(Assets.images.subscriptionTop),
        ),
      ],
    );
  }
}
