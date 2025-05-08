import 'package:flutter/material.dart';

import '../../../common/widgets/custom_gradient_text.dart';

class TabText extends StatelessWidget {
  final String title;
  final bool selected;
  const TabText({super.key, this.selected = false, required this.title});

  @override
  Widget build(BuildContext context) {
    TextStyle tabStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 12);

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Builder(
        builder: (context) {
          return !selected
              ? Text(title, style: tabStyle)
              : CustomGradientText(text: title, fontSize: 12);
        },
      ),
    );
  }
}
