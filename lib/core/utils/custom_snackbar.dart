import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void removeSnackBar(BuildContext context) {
    return ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  static Future showSnackBar(
    BuildContext context,
    Widget content, {
    Color? backgroundColor,
    SnackBarAction? action,
    Duration? duration,
    bool isTop = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return Flushbar(
      duration: duration ?? const Duration(seconds: 4),
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: Colors.blueGrey,
      flushbarPosition: isTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
      messageText: content,
    ).show(context);
  }
}
