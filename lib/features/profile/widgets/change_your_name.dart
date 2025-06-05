import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';

class ChangeYourName extends StatelessWidget {
  const ChangeYourName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        left: 12,
        right: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Change Name',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Space.h40,
          Row(children: [Text('Enter Your Full Name')]),
          Space.h12,
          CommonTextFormField(hintText: 'Alex'),
          Space.h40,

          GradientButton(
            onPressed: () {},
            child: Center(
              child: Text(
                'Save',
                style: AppTextTheme.mainButtonTextStyle(context).titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
