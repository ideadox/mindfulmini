import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomGradientText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final bool isBold;
  final int? maxLines;

  const CustomGradientText({
    required this.text,
    this.fontSize,
    this.maxLines,
    this.isBold = false,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => LinearGradient(
            colors: [
              HexColor('#6E40F9'),
              HexColor('#A569FB'),
              HexColor('#CE89FF'),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
