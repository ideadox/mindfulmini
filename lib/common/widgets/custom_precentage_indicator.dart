import 'package:flutter/material.dart';
import 'dart:math';

import 'package:hexcolor/hexcolor.dart';

class CustomPrecentageIndicator extends StatelessWidget {
  final double percent;

  const CustomPrecentageIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 60),
      painter: _CircularProgressPainter(percent),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percent;

  _CircularProgressPainter(this.percent);

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

    // Shadow behind active arc
    final shadowPaint =
        Paint()
          ..shader = SweepGradient(
            startAngle: -pi / 2,
            endAngle: -pi / 2 + 2 * pi * percent,
            colors: [
              HexColor('#F95D11').withOpacity(0.3),
              HexColor('#FCCB6C').withOpacity(0.3),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = strokeWidth + 6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percent,
      false,
      shadowPaint,
    );

    final gradientPaint =
        Paint()
          ..shader = SweepGradient(
            startAngle: -pi / 2,
            endAngle: -pi / 2 + 2 * pi * percent,
            colors: [HexColor('#F95D11'), HexColor('#FCCB6C')],
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percent,
      false,
      gradientPaint,
    );

    // Center text
    final textSpan = TextSpan(
      text: '${(percent * 100).round()}%',
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
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
