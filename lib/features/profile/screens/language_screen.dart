import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_radio_button.dart';

class LanguageScreen extends StatelessWidget {
  static String routeName = 'language-screen';
  static String routePath = '/language-screen';

  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text('Language'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('English'),
              trailing: GradientRadioButton(
                value: true,
                groupValue: true,
                onChanged: (val) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
