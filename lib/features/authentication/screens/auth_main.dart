import 'dart:io' show Platform;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/features/authentication/screens/login.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

import '../providers/phone_authh_provider.dart';
import '../providers/social_auth_provider.dart';

class AuthMain extends StatelessWidget {
  static String routeName = 'auth-main';
  static String routePath = '/auth-main';

  const AuthMain({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context); // e.g., Locale('en', 'IN')
    final countryCode = locale.countryCode;
    final remoteConfig = sl<RemoteConfigService>();
    final strings = remoteConfig.strings;
    final flags = remoteConfig.flags;
    final enablePhoneLogin = flags.auth('enable_phone_login', fallback: true);
    final enableSocialLogin = flags.auth('enable_social_login', fallback: true);
    final enableGoogleLogin = flags.auth('enable_google_login', fallback: true);
    final enableAppleLogin = flags.auth('enable_apple_login', fallback: true);
    final enableEmailLogin = flags.auth('enable_email_login', fallback: true);
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
                strings.auth('auth_main_title', fallback: 'Let\'s get Started!'),
                style: TextTheme.of(context).titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                strings.auth('auth_main_subtitle', fallback: 'Enter Mobile Number'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),

              if (enablePhoneLogin) ...[
                SizedBox(
                  height: 56,
                  child: TextFormField(
                    controller:
                        context.read<PhoneAuthhProvider>().phoneNumerController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                    decoration: InputDecoration(
                      hintText: strings.auth(
                        'auth_main_phone_hint',
                        fallback: 'Mobile Number',
                      ),
                      fillColor: Colors.white,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      filled: true,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 110,
                        maxWidth: 130,
                      ),
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CountryCodePicker(
                            initialSelection: countryCode,
                            favorite: ["+91"],
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            onInit: (value) {
                              context.read<PhoneAuthhProvider>().countryCode =
                                  value?.dialCode ?? '+91';
                            },
                            onChanged: (value) {
                              context.read<PhoneAuthhProvider>().countryCode =
                                  value.dialCode;
                            },
                            padding: EdgeInsets.zero,
                            boxDecoration: const BoxDecoration(),
                          ),
                          Container(
                            width: 1,
                            height: 26,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
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
                        strings.auth('auth_main_primary_cta', fallback: 'Go'),
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
              ],

              if (enableSocialLogin) ...[
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
                        strings.auth(
                          'auth_main_or_continue_with',
                          fallback: 'Or continue with',
                        ),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                SizedBox(height: 20),
                Consumer<SocialAuthProvider>(
                  builder: (context, socialAuth, _) {
                    return Column(
                      children: [
                        if (socialAuth.isLoading)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Apple Sign-In: only shown on iOS
                              if (Platform.isIOS && enableAppleLogin) ...[
                                AuthOption(
                                  icon: Assets.icons.appleLogo,
                                  onPressed: () => socialAuth.signInWithApple(),
                                ),
                                SizedBox(width: 20),
                              ],
                              if (enableGoogleLogin)
                                AuthOption(
                                  icon: Assets.icons.googleLogo,
                                  onPressed: () => socialAuth.signInWithGoogle(),
                                ),
                            ],
                          ),
                        if (socialAuth.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              socialAuth.error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],

              if (enableEmailLogin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      strings.auth(
                        'auth_main_existing_account',
                        fallback: 'Already have an account?',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        sl<GoRouter>().pushNamed(Login.routeName);
                      },
                      child: Text(
                        strings.auth('auth_main_login_cta', fallback: 'Log In'),
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

              Center(
                child: Text(
                  strings.auth(
                    'auth_main_terms_prefix',
                    fallback: 'By signing up, you agree to our',
                  ),
                ),
              ),
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: strings.auth(
                          'auth_main_terms_text',
                          fallback: 'Terms & Conditions',
                        ),
                        style: TextStyle(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: strings.auth('auth_main_and_text', fallback: ' and '),
                      ),
                      TextSpan(
                        text: strings.auth(
                          'auth_main_privacy_text',
                          fallback: 'Privacy Policy.',
                        ),
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
