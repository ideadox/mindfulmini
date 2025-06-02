import 'dart:math';

import 'package:flutter/material.dart';

class DurationLevel {
  final Duration invested;
  final Duration total;
  final Color color;

  DurationLevel({
    required this.invested,
    required this.total,
    required this.color,
  });
}

class _MultiSegmentPainter extends CustomPainter {
  final List<DurationLevel> levels;
  final double strokeWidth;
  final double gapDegrees;
  final double shadowBlur;

  _MultiSegmentPainter({
    required this.levels,
    this.strokeWidth = 12,
    this.gapDegrees = 6,
    this.shadowBlur = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final totalGapRadians = gapDegrees * pi / 180 * levels.length;
    final totalDuration = levels.fold<Duration>(
      Duration.zero,
      (sum, l) => sum + l.total,
    );

    final totalAvailableArc = 2 * pi - totalGapRadians;
    final gapRadians = gapDegrees * pi / 180;

    double startAngle = -pi / 2;

    for (var level in levels) {
      final levelFraction =
          level.total.inMilliseconds / totalDuration.inMilliseconds;
      final levelArc = totalAvailableArc * levelFraction;

      final investedFraction =
          level.invested.inMilliseconds / level.total.inMilliseconds;
      final investedArc = levelArc * investedFraction;

      // Grey base (full arc)
      final basePaint =
          Paint()
            ..color = Colors.grey.shade300
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, levelArc, false, basePaint);

      // Optional shadow for invested arc
      if (shadowBlur > 0) {
        final shadowPaint =
            Paint()
              ..color = level.color.withOpacity(0.5)
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth + 2
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

        canvas.drawArc(rect, startAngle, investedArc, false, shadowPaint);
      }

      // Invested arc
      final fillPaint =
          Paint()
            ..color = level.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, investedArc, false, fillPaint);

      startAngle += levelArc + gapRadians;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomSegemtPercentIndicator extends StatelessWidget {
  final List<DurationLevel> levels;
  final Widget? child;
  const CustomSegemtPercentIndicator({
    super.key,
    required this.levels,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(size.width * 0.4, size.width * 0.4),
          painter: _MultiSegmentPainter(
            levels: levels,
            strokeWidth: 10,
            gapDegrees: 6,
            shadowBlur: 6,
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
