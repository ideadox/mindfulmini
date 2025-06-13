import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/features/forgot_password/providers/forgot_password_provider.dart';
import 'package:mindfulminis/features/forgot_password/screens/change_password.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/common_text_form_field.dart';

class ForgotPassword extends StatelessWidget {
  static String routeName = 'forgot-password';
  static String routePath = '/forgot-password';
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotpasswordProvider(),
      child: GradientScaffold(
        body: Consumer<ForgotpasswordProvider>(
          builder: (context, cap, _) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(),
                  Text(
                    'Let’s reset your \n password',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 30),

                  CommonTextFormField(
                    controller: cap.emailController,
                    prefixIcon: SvgPicture.asset(Assets.icons.mail),
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter email.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),
                  if (cap.message != null)
                    Text(
                      'Please check your email, and follow the instructions',
                    ),
                  Spacer(),

                  GradientButton(
                    onPressed:
                        cap.isLoading
                            ? null
                            : () {
                              // cap.sendResetLink();
                              sl<GoRouter>().pushNamed(
                                ChangePassword.routeName,
                              );
                            },
                    child:
                        cap.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
