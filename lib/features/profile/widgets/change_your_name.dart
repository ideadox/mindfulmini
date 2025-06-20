import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/profile/models/user_profile.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ChangeYourName extends StatefulWidget {
  final String name;
  const ChangeYourName({super.key, required this.name});

  @override
  State<ChangeYourName> createState() => _ChangeYourNameState();
}

class _ChangeYourNameState extends State<ChangeYourName> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    nameController.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
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
              CommonTextFormField(hintText: 'Name', controller: nameController),
              Space.h40,

              GradientButton(
                onPressed:
                    provider.updating
                        ? null
                        : () async {
                          try {
                            UserProfile updatedProfile = provider.userProfile
                                .copyWith(
                                  firstName: nameController.text.trim(),
                                );
                            await provider.updateProfile(updatedProfile);
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                child: Center(
                  child:
                      provider.updating
                          ? CircularProgressIndicator()
                          : Text(
                            'Save',
                            style:
                                AppTextTheme.mainButtonTextStyle(
                                  context,
                                ).titleLarge,
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
