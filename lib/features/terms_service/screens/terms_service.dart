import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/custom_back_button.dart';

class TermsService extends StatelessWidget {
  static String routeName = 'terms-service-screen';
  static String routePath = '/terms-service-screen';

  const TermsService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text(
          'Terms of Service',
          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
