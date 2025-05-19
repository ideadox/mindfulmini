import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static HexColor primary = HexColor('#8E00FF');
  static HexColor purple = HexColor('#9D9FE6');

  static Color grey45 = Colors.grey;
  static HexColor whitehex = HexColor('#FFFFFF');
  static HexColor dividerColor = HexColor('#ACADBC42');

  static List<HexColor> primaryGradientColors = [
    HexColor('#6E40F9'),
    HexColor('#A569FB'),
    HexColor('#CE89FF'),
  ];
  static List<Color> secondaryGradientColors = [
    HexColor('#6E40F9').withValues(alpha: 0.5),
    HexColor('#A569FB').withValues(alpha: 0.5),
    HexColor('#CE89FF').withValues(alpha: 0.5),
  ];

  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,

    colors: AppColors.primaryGradientColors,
  );
  static LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,

    colors: AppColors.secondaryGradientColors,
  );
}
