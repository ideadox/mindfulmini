import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/gradient_scaffold.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';

import 'package:mindfulminis/gen/assets.gen.dart';

import 'package:provider/provider.dart';

import '../../../core/app_text_theme.dart';
import '../providers/onboards_provider.dart';

class Dob extends StatelessWidget {
  static String routeName = 'dob-name';
  static String routePath = '/dob-path';

  const Dob({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> dobFormKey = GlobalKey();

    return GradientScaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<OnboardsProvider>(
          builder: (context, provider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),

                Text(
                  'How old is your child?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 20),
                Form(
                  key: dobFormKey,
                  child: CommonTextFormField(
                    controller: provider.dobController,
                    readOnly: true,
                    prefixIcon: SvgPicture.asset(Assets.icons.dobIcon),
                    hintText: 'Date Of Birth',
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return 'Please select date of birth.';
                      }

                      return null;
                    },
                  ),
                ),

                Spacer(flex: 1),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        height: MediaQuery.sizeOf(context).height * 0.35,
                        child: CupertinoDatePicker(
                          itemExtent: 40,

                          initialDateTime: DateTime.now(),
                          mode: CupertinoDatePickerMode.date,
                          maximumDate: DateTime.now(),
                          minimumDate: DateTime.now().subtract(
                            const Duration(days: 100 * 365),
                          ),
                          use24hFormat: true,

                          showDayOfWeek: false,
                          onDateTimeChanged: (DateTime newDate) {
                            provider.onChangeDob(newDate);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Space.h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Age : '),

                    if (provider.selectedDob != null)
                      CustomGradientText(
                        text:
                            '${AppFormate.calculateAge(provider.selectedDob!)} Year old',
                        isBold: true,
                      ),
                  ],
                ),
                Space.h12,
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.purple.withValues(alpha: 0.1),
                    ),
                    child: Text(
                      "This app works best for  5-10 year old's",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 3),
                GradientButton(
                  onPressed: () {
                    if (dobFormKey.currentState!.validate()) {
                      provider.onDateOfBirthSave();
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
            );
          },
        ),
      ),
    );
  }
}
