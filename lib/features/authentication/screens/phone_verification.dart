import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';

import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/authentication/providers/phone_authh_provider.dart';

import 'package:provider/provider.dart';

class PhoneVerification extends StatelessWidget {
  static String routeName = 'otp-verification';
  static String routePath = '/otp-verification';

  const PhoneVerification({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Consumer<PhoneAuthhProvider>(
      builder: (context, provider, _) {
        return GradientScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'We’ve send you the verification code on \n${provider.phoneNumber}',
                      style: TextStyle(color: AppColors.grey45),
                    ),
                    SizedBox(height: 30),

                    OtpTextField(
                      handleControllers: (controllers) {
                        provider.otpControllers = controllers;
                      },
                      borderWidth: 0.3,
                      fieldHeight: 70,

                      fieldWidth: width / 8,
                      filled: true,
                      fillColor: Colors.white,
                      decoration: InputDecoration(),
                      numberOfFields: 6,
                      disabledBorderColor: AppColors.grey45,
                      enabledBorderColor:
                          provider.error != null ? Colors.red : Colors.black26,
                      borderColor: AppColors.primary,

                      showFieldAsBox: true,

                      onCodeChanged: (String code) {
                        provider.onCodeChanged();
                      },
                      borderRadius: BorderRadius.circular(10),

                      onSubmit: (String verificationCode) {
                        provider.code = verificationCode;
                      },
                    ),
                    SizedBox(height: 20),
                    GradientButton(
                      onPressed: () {
                        provider.onPhoneAuthVerificationCodeSubmit();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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

                    if (provider.error != null) ...[
                      SizedBox(height: 20),
                      Text(
                        provider.error ?? '',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                      ),
                    ],
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              if (provider.leftSeconds != 0)
                                TextSpan(text: 'Re-send code in '),
                              if (provider.leftSeconds != 0)
                                TextSpan(
                                  text: provider.formatSeconds(
                                    provider.leftSeconds,
                                  ),
                                ),
                              if (provider.leftSeconds == 0)
                                TextSpan(
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          provider.phoneAuthSubmit();
                                        },
                                  text: 'Resend',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
