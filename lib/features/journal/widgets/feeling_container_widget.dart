import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class FeelingContainerWidget extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;
  final bool selected;
  final bool makeGrey;
  const FeelingContainerWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.selected = false,
    this.makeGrey = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient:
                  !selected
                      ? null
                      : LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,

                        colors: [
                          HexColor('#6E40F9'),

                          HexColor('#A569FB'),
                          HexColor('#CE89FF'),
                        ],
                      ),
            ),
            child: Opacity(
              opacity: selected == false && makeGrey == true ? 0.5 : 1.0,
              child: SvgPicture.asset(icon),
            ),
          ),
          Space.h16,

          if (selected) CustomGradientText(text: title),
          if (!selected)
            Opacity(
              opacity: selected == false && makeGrey == true ? 0.5 : 1.0,

              child: Text(title),
            ),
        ],
      ),
    );
  }
}
