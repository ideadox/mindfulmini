import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';

class CommonAppbar extends StatelessWidget {
  final Widget? title;
  final bool hasBackground;
  const CommonAppbar({super.key, this.title, this.hasBackground = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Stack(
        alignment: Alignment.center,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              CustomBackButton(hasBackground: hasBackground),
              SizedBox(width: 48),
            ],
          ),

          Center(child: title),
        ],
      ),
    );
  }
}
