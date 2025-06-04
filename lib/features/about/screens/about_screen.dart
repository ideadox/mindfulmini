import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/terms_service/models/terms_model.dart';

import '../../../common/widgets/custom_back_button.dart';

class AboutScreen extends StatelessWidget {
  static String routeName = 'about-screen';
  static String routePath = '/about-screen';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<TermsModel> _terms = [
      TermsModel(
        title: 'What is Lorem Ipsum?',
        body:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text(
          'About',
          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _terms[0].title,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Space.h20,
              Text(_terms[0].body),
            ],
          );
        },
        separatorBuilder: (context, index) => Space.h20,
        itemCount: 5,
      ),
    );
  }
}
