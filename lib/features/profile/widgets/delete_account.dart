import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 155),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Space.h12,

                  Text(
                    textAlign: TextAlign.center,

                    'Are you sure you want\nto say goodbye? 😔',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Space.h20,
                  Text(
                    textAlign: TextAlign.center,

                    ' By confirming "Delete," your account will be permanently removed.',
                    style: TextStyle(fontSize: 16),
                  ),
                  Space.h20,

                  Text(
                    textAlign: TextAlign.center,

                    'We’re sad to see you leave 😢, but we understand. If you’re ready to go, we’ll make it happen. If not, your calm and mindful space will always be here waiting for you! 🌈',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                  ),
                  Space.h20,

                  GradientButton(
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        'Delete Account',
                        style:
                            AppTextTheme.mainButtonTextStyle(
                              context,
                            ).titleLarge,
                      ),
                    ),
                  ),
                  Space.h12,

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            foregroundColor: Colors.black,
                            side: BorderSide(color: AppColors.purple),
                          ),
                          onPressed: () {},
                          child: Text('Keep My Account'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Image.asset(Assets.images.deleteAccountImage.path),
        ),
      ],
    );
  }
}
