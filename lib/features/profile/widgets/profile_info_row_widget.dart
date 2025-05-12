import 'package:flutter/material.dart';

class ProfileInfoRowWidget extends StatelessWidget {
  final String title;
  final String value;
  final Widget? trailing;
  const ProfileInfoRowWidget({
    super.key,
    required this.title,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ],
    );
  }
}
