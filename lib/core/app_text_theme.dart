import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';

class AppTextTheme {
  static TextTheme titleTextTheme(BuildContext context) {
    final base = Theme.of(context).textTheme;

    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        color: Colors.grey.shade800,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      // Add more overrides as needed
    );
  }

  static TextTheme mainButtonTextStyle(BuildContext context) {
    final base = Theme.of(context).textTheme;
    return base.copyWith(
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  static TextTheme bodyTextStyle(BuildContext context) {
    final base = Theme.of(context).textTheme;
    return base.copyWith(
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      ),
    );
  }
}
