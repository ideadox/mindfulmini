// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';

// class CustomPrecentageIndicator extends StatelessWidget {
//   final double percent;

//   const CustomPrecentageIndicator({super.key, required this.percent});

//   @override
//   Widget build(BuildContext context) {
//     double size = 65;

//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: HexColor('#F95D11').withOpacity(0.4),
//             blurRadius: 12,
//             spreadRadius: 4,
//           ),
//           BoxShadow(
//             color: HexColor('#FCCB6C').withOpacity(0.4),
//             blurRadius: 16,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           ShaderMask(
//             shaderCallback: (Rect bounds) {
//               return SweepGradient(
//                 startAngle: 0.0,
//                 endAngle: 3.14 * 2,
//                 stops: [percent, percent],
//                 center: Alignment.center,
//                 colors: [HexColor('#F95D11'), Colors.grey.shade300],
//               ).createShader(bounds);
//             },
//             child: Container(
//               width: size,
//               height: size,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Container(
//             width: size * 0.85,
//             height: size * 0.85,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               '${(percent * 100).round()}%',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: HexColor('#F95D11'),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:math';

class CustomPrecentageIndicator extends StatelessWidget {
  final double percent; // 0.0 to 1.0

  const CustomPrecentageIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(150, 150),
      painter: _CircularProgressPainter(percent),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percent;

  _CircularProgressPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 16.0;
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
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

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
        fontSize: 22,
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

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }
}
