import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_spacing.dart';

class LibraryEmptyData extends StatelessWidget {
  final String icon, title, subtitle;
  final bool space;

  const LibraryEmptyData({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.space = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon),
        if (space) Space.h20,

        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Space.h8,
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
