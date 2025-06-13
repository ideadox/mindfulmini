import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class ChangePassword extends StatelessWidget {
  static String routeName = 'change-password';
  static String routePath = '/change-password';
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kTextTabBarHeight + 20),
            Text(
              'Change Password',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            Space.h16,
            Text(
              'Enter your new password in the box below and click Save This Password.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
              ),
            ),
            Space.h20,
            CommonTextFormField(hintText: 'New Password'),
            Space.h12,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Your password reset has expired. Please re-enter email to try again.',
                style: TextStyle(color: Colors.red),
              ),
            ),
            // Center(
            //   child: Text(
            //     'Your password has been changed.',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(color: Colors.green),
            //   ),
            // ),
            Space.h20,
            GradientButton(
              onPressed: () {},
              child: Center(
                child: Text(
                  'Save This Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Space.h20,
            Text(
              "If you're having trouble please visit our help center article, Sign Into Happier with an Existing Account, or contact the support team at support@mindfulminicom",

              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
