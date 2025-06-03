import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class CommonTextFormField extends StatelessWidget {
  final Widget? prefixIcon;
  final String? hintText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;

  const CommonTextFormField({
    super.key,
    this.prefixIcon,
    this.hintText,
    this.suffixIcon,
    this.validator,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        prefixIconConstraints:
            prefixIcon == null
                ? null
                : BoxConstraints(minWidth: 60, maxWidth: 100),
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.grey45, fontSize: 16),
        prefixIcon:
            prefixIcon == null
                ? null
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(height: 24, width: 24, child: prefixIcon),
                ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.whitehex,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.purple),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
