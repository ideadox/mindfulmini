import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/authentication/screens/login.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

import '../providers/phone_authh_provider.dart';

class AuthMain extends StatelessWidget {
  static String routeName = 'auth-main';
  static String routePath = '/auth-main';

  const AuthMain({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context); // e.g., Locale('en', 'IN')
    final countryCode = locale.countryCode;
    return GradientScaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'Let’s get Started!',
                style: TextTheme.of(context).titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                'Enter Mobile Number ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CountryCodePicker(
                      initialSelection: countryCode,
                      favorite: ["+91"],
                      onChanged: (value) {
                        context.read<PhoneAuthhProvider>().countryCode =
                            value.dialCode;
                      },
                      padding: EdgeInsets.zero,
                      boxDecoration: BoxDecoration(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          controller:
                              context
                                  .read<PhoneAuthhProvider>()
                                  .phoneNumerController,
                          decoration: InputDecoration(
                            hintText: 'Mobile Number',
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                            filled: true,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              GradientButton(
                onPressed: () {
                  context.read<PhoneAuthhProvider>().phoneAuthSubmit();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Go',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_outlined, color: Colors.white),
                  ],
                ),
              ),
              SizedBox(height: 100),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthOption(icon: Assets.icons.appleLogo, onPressed: () {}),
                  SizedBox(width: 20),
                  AuthOption(icon: Assets.icons.googleLogo, onPressed: () {}),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      sl<GoRouter>().pushNamed(Login.routeName);
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 50),
              Spacer(),

              Center(child: Text('By signing up, you agree to our ')),
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(color: AppColors.primary),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              Space.h20,
            ],
          ),
        ),
      ),
    );
  }
}

class AuthOption extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  const AuthOption({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: SvgPicture.asset(icon, height: 24, width: 24),
      ),
    );
  }
}
