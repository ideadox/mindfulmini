import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/authentication/screens/auth_main.dart';
import 'package:mindfulminis/features/forgot_password/screens/forgot_password.dart';
import 'package:mindfulminis/features/authentication/screens/create_account.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/common_text_form_field.dart';
import '../../../common/widgets/custom_back_button.dart';
import '../providers/login_provider.dart';

class Login extends StatelessWidget {
  static String routeName = 'login';
  static String routePath = '/login';
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: GradientScaffold(
        body: Consumer<LoginProvider>(
          builder: (context, cap, _) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: cap.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackButton(),
                    Text(
                      'Let’s Log In',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Welcome Back,You have been missed.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.grey45),
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

                    CommonTextFormField(
                      controller: cap.passwordController,
                      obscureText: cap.isVisible,
                      prefixIcon: SvgPicture.asset(Assets.icons.passLock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          cap.toogleVisiblity();
                        },
                        icon: SvgPicture.asset(
                          cap.isVisible
                              ? Assets.icons.visibleEye
                              : Assets.icons.invisbleEye,
                        ),
                      ),
                      hintText: 'Enter Password',
                      keyboardType: TextInputType.visiblePassword,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Please enter password.';
                        }
                        if (p0.length < 8) {
                          return 'Passwords must be at least 8 characters long.';
                        }
                        return null;
                      },
                    ),
                    if (cap.error != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            cap.error ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ),
                      ),
                    SizedBox(height: 30),

                    Center(
                      child: InkWell(
                        onTap: () {
                          sl<GoRouter>().pushNamed(ForgotPassword.routeName);
                        },
                        child: Text(
                          'Forgot Password ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),

                    GradientButton(
                      onPressed:
                          cap.isLoading
                              ? null
                              : () async {
                                try {
                                  await cap.login();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                      child: Center(
                        child:
                            cap.isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                  'Go',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don’t have any account? "),
                        TextButton(
                          onPressed: () {
                            sl<GoRouter>().pushReplacementNamed(
                              CreateAccount.routeName,
                            );
                          },
                          child: Text('Register Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
