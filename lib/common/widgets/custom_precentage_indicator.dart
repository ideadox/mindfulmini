import 'package:flutter/material.dart';
import 'dart:math';
import 'package:hexcolor/hexcolor.dart';

class CustomPercentageIndicator extends StatelessWidget {
  /// Accepts either a fraction (0.0 - 1.0) or percentage (0 - 100).
  /// Internally it normalizes to 0.0..1.0.
  final double percent;

  const CustomPercentageIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 60),
      painter: _CircularProgressPainter(percent),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double rawPercent;
  _CircularProgressPainter(this.rawPercent);

  // Convert rawPercent to normalized 0..1
  double get _percent {
    if (rawPercent.isNaN) return 0.0;
    if (rawPercent <= 1.0) return rawPercent.clamp(0.0, 1.0);
    // if > 1 treat as 0..100 value
    return (rawPercent / 100.0).clamp(0.0, 1.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 3.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final backgroundPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    final percent = _percent;
    final sweep = 2 * pi * percent;

    // If sweep is zero, skip drawing arc/shadow/gradient
    if (sweep > 0.0001) {
      // Shadow behind active arc (soft glow)
      final shadowPaint =
          Paint()
            ..shader = SweepGradient(
              startAngle: -pi / 2,
              endAngle: -pi / 2 + sweep,
              colors: [
                HexColor('#F95D11').withOpacity(0.25),
                HexColor('#FCCB6C').withOpacity(0.25),
              ],
            ).createShader(Rect.fromCircle(center: center, radius: radius))
            ..strokeWidth = strokeWidth + 6
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweep,
        false,
        shadowPaint,
      );

      // Gradient for active arc
      // If percent is 1.0, avoid exactly 2π (use tiny epsilon)
      final safeSweep = (percent >= 1.0) ? (2 * pi - 0.0001) : sweep;

      final gradientPaint =
          Paint()
            ..shader = SweepGradient(
              startAngle: -pi / 2,
              endAngle: -pi / 2 + safeSweep,
              colors: [HexColor('#F95D11'), HexColor('#FCCB6C')],
            ).createShader(Rect.fromCircle(center: center, radius: radius))
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        safeSweep,
        false,
        gradientPaint,
      );
    }

    // Center text - show percentage as integer 0..100
    final displayPercent = (_percent * 100).round();
    final textSpan = TextSpan(
      text: '$displayPercent%',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    // repaint only when normalized percent changes
    return (_percent - oldDelegate._percent).abs() > 0.0001;
  }
}
