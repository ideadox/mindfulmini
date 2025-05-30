import 'package:flutter/material.dart';

class AffirContainerDesign {
  final double start;
  final double end;
  final Color? color;
  final bool hasShadow;
  final bool hasTextShadow;
  final bool isGradint;
  final List<Color>? gradientColor;

  AffirContainerDesign({
    required this.start,
    required this.end,
    this.color,
    this.hasShadow = false,
    this.isGradint = false,
    this.hasTextShadow = false,
    this.gradientColor,
  });
}
