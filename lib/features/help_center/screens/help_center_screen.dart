import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/common_text_form_field.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class HelpCenterScreen extends StatelessWidget {
  static String routeName = 'help-center-screen';
  static String routePath = '/help-center-screen';

  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text(
          'Help Center',
          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                'Please enter a brief description of your issue or question and one of our team will be with you as soon as possible',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              Space.h16,
              CommonTextFormField(hintText: 'Enter your name'),
              Space.h20,
              CommonTextFormField(hintText: 'Enter your email address'),
              Space.h20,
              CommonTextFormField(hintText: 'Your message', maxLines: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GradientButton(
              gradientColors: [HexColor("#CFC0FF"), HexColor('#9D9FE6')],
              onPressed: () {},
              child: Center(
                child: Text(
                  'Save',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Space.h12,
            Text(
              'We may collect device & account information to assist with your enquiry.\nRefer to our Privacy Policy for further information',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Space.h12,
          ],
        ),
      ),
    );
  }
}
