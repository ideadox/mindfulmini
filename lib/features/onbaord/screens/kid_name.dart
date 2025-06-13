import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/onbaord/providers/onboards_provider.dart';

import 'package:mindfulminis/gen/assets.gen.dart';

import 'package:provider/provider.dart';

import '../../../core/app_text_theme.dart';

class KidName extends StatelessWidget {
  static String routeName = 'kid-name';
  static String routePath = '/kid-name';

  const KidName({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> nameFormKey = GlobalKey();

    return GradientScaffold(
      body: Consumer<OnboardsProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),

                Text(
                  'Your kid’s name',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Enter any cute or funny name that your kids like the most',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: AppColors.grey45,
                  ),
                ),
                SizedBox(height: 30),

                Form(
                  key: nameFormKey,
                  child: CommonTextFormField(
                    controller: provider.nameController,
                    prefixIcon: SvgPicture.asset(Assets.icons.user),
                    keyboardType: TextInputType.name,
                    hintText: 'Enter Name',
                    
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please enter name.';
                      }
                      if (p0.length < 3) {
                        return 'Please enter a name with at least 3 alphabetic characters.';
                      }
                      return null;
                    },
                  ),
                ),

                Spacer(),
                GradientButton(
                  onPressed: () {
                    if (nameFormKey.currentState!.validate()) {
                      provider.onNameSave();
                    }
                  },
                  child: Center(
                    child: Text(
                      'Save',
                      style:
                          AppTextTheme.mainButtonTextStyle(context).titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
