import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class OverallChart extends StatelessWidget {
  final double value;
  final List<Color> gradientColors;
  final double strokeWidth;

  const OverallChart({
    super.key,
    required this.value,
    required this.gradientColors,
    this.strokeWidth = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: const Size(215, 117),
          painter: _SemicircleChartPainter(
            value: value.clamp(0, 100),
            gradientColors: gradientColors,
            strokeWidth: strokeWidth,
          ),
        ),
        Column(
          children: [
            Text(
              '${value.toInt()}%',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Space.h8,
            Text(
              'Completion Rate',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class _SemicircleChartPainter extends CustomPainter {
  final double value;
  final List<Color> gradientColors;
  final double strokeWidth;

  _SemicircleChartPainter({
    required this.value,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = pi;
    final sweepAngle = pi * (value / 100);

    // Background arc (purple 10%)
    final backgroundPaint =
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, pi, false, backgroundPaint);

    // thumbBack circle
    final thumbBackangle = startAngle + sweepAngle;
    final thumbBackX = center.dx + radius * cos(thumbBackangle);
    final thumbBackY = center.dy + radius * sin(thumbBackangle);

    final thumbBackPaint = Paint()..color = Colors.grey.shade300;
    canvas.drawCircle(Offset(thumbBackX, thumbBackY), 20, thumbBackPaint);

    // Draw shadow arc separately
    final shadowArcPaint =
        Paint()
          ..shader = SweepGradient(
            startAngle: pi,
            endAngle: pi * 2,
            colors: gradientColors,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 4
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            6,
          ); // blur only on shadow

    canvas.drawArc(rect, startAngle, sweepAngle, false, shadowArcPaint);

    // Draw main arc (no blur)
    final arcPaint =
        Paint()
          ..shader = SweepGradient(
            startAngle: pi,
            endAngle: pi * 2,
            colors: gradientColors,
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);

    // Thumb background shadow (grey outer circle)
    final thumbAngle = startAngle + sweepAngle;
    final thumbX = center.dx + radius * cos(thumbAngle);
    final thumbY = center.dy + radius * sin(thumbAngle);

    // Thumb (white center)
    canvas.drawCircle(
      Offset(thumbX, thumbY),
      strokeWidth / 3.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
