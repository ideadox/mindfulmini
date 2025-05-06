import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/features/login/screens/login.dart';
import 'package:mindfulminis/features/signup/providers/create_account_provoider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/common_text_form_field.dart';
import '../../../injection/injection.dart';

class CreateAccount extends StatelessWidget {
  static String routeName = 'create-account';
  static String routePath = '/create-account';
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateAccountProvoider(),
      child: GradientScaffold(
        body: Consumer<CreateAccountProvoider>(
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
                      'Create an account',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 30),
                    CommonTextFormField(
                      controller: cap.nameController,
                      prefixIcon: SvgPicture.asset(Assets.icons.user),
                      hintText: 'Enter Full Name',
                      keyboardType: TextInputType.name,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Please enter name.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

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
                      hintText: 'Create Password',
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
                    Spacer(),

                    GradientButton(
                      onPressed:
                          cap.loading
                              ? null
                              : () {
                                cap.signUp();
                              },
                      child: Center(
                        child:
                            cap.loading
                                ? CircularProgressIndicator()
                                : Text(
                                  'Create',
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
                        Text("Already have any account? "),
                        TextButton(
                          onPressed: () {
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return Login();
                            //     },
                            //   ),
                            // );
                            sl<GoRouter>().pushReplacementNamed(
                              Login.routeName,
                            );
                          },
                          child: Text('Log In'),
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
