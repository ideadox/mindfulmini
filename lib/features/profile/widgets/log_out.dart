import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class LogOut extends StatelessWidget {
  const LogOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 0,
          child: Image.asset(Assets.images.deleteAccountImage.path),
        ),
        Container(
          margin: EdgeInsets.only(top: 90),
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

                    'Are you sure you want\nto log out?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Space.h20,

                  GradientButton(
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        'Yes, Log Me Out',
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
                          child: Text('Stay Logged In'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
