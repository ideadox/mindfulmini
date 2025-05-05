import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/common_text_form_field.dart';
import '../providers/login_provider.dart';

class Login extends StatelessWidget {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Let’s Log In',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('Welcome Back,You have been missed.'),
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
                  SizedBox(height: 30),

                  Center(
                    child: Text(
                      'Forgot Password ',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  Spacer(),

                  GradientButton(
                    onPressed: () {},
                    child: Center(
                      child: Text(
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
                      TextButton(onPressed: () {}, child: Text('Register Now')),
                    ],
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
