import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/features/authentication/providers/phone_authh_provider.dart';
import 'package:mindfulminis/features/authentication/screens/phone_verification.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class AuthMain extends StatelessWidget {
  const AuthMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Text(
                'Login In Or Sign Up',
                style: TextTheme.of(context).titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to MindfulMinis! Please log in to save your progress!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter your mobile Number ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CountryCodePicker(
                      padding: EdgeInsets.zero,
                      boxDecoration: BoxDecoration(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 58,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              GradientButton(
                onPressed: () {
                  // context.read<PhoneAuthhProvider>().phoneAuthSubmit('erfer');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PhoneVerification();
                      },
                    ),
                  );
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
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text('Or continue with'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),

                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: SvgPicture.asset(
                      Assets.icons.appleLogo,
                      height: 24,
                      width: 24,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: SvgPicture.asset(
                      Assets.icons.googleLogo,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(onPressed: () {}, child: Text('Log In')),
                ],
              ),
              SizedBox(height: 30),
              Center(child: Text('By signing up, you agree to our ')),
              Center(
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(text: 'Terms & Conditions'),
                      TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
