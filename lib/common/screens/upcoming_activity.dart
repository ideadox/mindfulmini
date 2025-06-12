import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/play%20visuals/screen/play_visuals.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class UpcomingActivity extends StatelessWidget {
  const UpcomingActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(30),
          right: Radius.circular(30),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            HexColor('#FFF9E8'),
            HexColor('#D4E1FE'),
            HexColor('#FDE8EF'),
            HexColor('#FFF4EE'),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Positioned(
          //   left: 0,
          //   child: Image.asset(Assets.vectors.upactLeft.path),
          // ),
          // Positioned(
          //   right: 0,
          //   child: Opacity(
          //     opacity: 0.5,
          //     child: Image.asset(Assets.vectors.upactRightgif.path),
          //   ),
          // ),
          Positioned(
            bottom: 0,
            child: Image.asset(Assets.vectors.apactmain.path),
          ),

          UpcomingActivityContent(),
        ],
      ),
    );
  }
}

class UpcomingActivityContent extends StatelessWidget {
  const UpcomingActivityContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Space.h20,
        Container(
          height: 5,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Space.h20,
        BuildSteps(totalSteps: 4, currentStep: 2),
        Space.h20,

        Text(
          '🦋 Flutter Like a Butterfly!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        Space.h20,
        Space.h20,

        Text(
          'Amazing job so far! Now,\n Ready to flutter and fly?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.black38,
          ),
        ),
        Space.h20,

        CountdownCircle(
          duration: const Duration(seconds: 5),
          onComplete: () {
            sl<GoRouter>().pop();
            sl<GoRouter>().pushReplacementNamed(PlayVisuals.routeName);
          },
        ),

        SizedBox(height: 300),
      ],
    );
  }
}

class BuildSteps extends StatelessWidget {
  final int totalSteps, currentStep;
  const BuildSteps({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 17,
      width: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: totalSteps,
              itemBuilder: (context, index) {
                bool isActive = index < currentStep;
                return Row(
                  children: [
                    Container(
                      height: 17,
                      width: 17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color:
                            !isActive
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : null,
                        gradient:
                            !isActive
                                ? null
                                : LinearGradient(
                                  colors: AppColors.primaryGradientColors,
                                ),
                      ),
                      child: Icon(
                        Icons.check,
                        color: isActive ? Colors.white : Colors.transparent,
                        size: 10,
                      ),
                    ),
                    if (index < totalSteps - 1)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 1.8,

                        width: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                index < currentStep - 1
                                    ? AppColors.primaryGradientColors
                                    : AppColors.secondaryGradientColors,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CountdownCircle extends StatefulWidget {
  final Duration duration;
  final double size;
  final VoidCallback? onComplete;

  const CountdownCircle({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.size = 100,
    this.onComplete,
  });

  @override
  State<CountdownCircle> createState() => _CountdownCircleState();
}

class _CountdownCircleState extends State<CountdownCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 1) {
        timer.cancel();
        widget.onComplete?.call();
      }
      setState(() {
        _remainingSeconds--;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(110, 110),
          painter: ProgressPainter(0.0 + _controller.value),
        ),

        Column(
          children: [
            Text(
              _remainingSeconds == 0
                  ? _remainingSeconds.toString()
                  : _remainingSeconds.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            Text('Sec'),
          ],
        ),
      ],
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double percent;

  ProgressPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 3.0;
    final center = Offset(size.width / 2, size.height / 2);

    double startAngle = -pi / 2;

    final radius = size.width / 2 - strokeWidth / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track
    final backgroundPaint =
        Paint()
          ..color = Colors.white70
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Shadow behind active arc
    final shadowPaint =
        Paint()
          ..shader = SweepGradient(
            startAngle: startAngle,
            endAngle: 2 * pi * percent,
            colors: AppColors.primaryGradientColors,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..strokeWidth = strokeWidth + 1
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawArc(rect, -pi / 2, 2 * pi * percent, false, shadowPaint);

    final gradientPaint =
        Paint()
          ..shader = SweepGradient(
            startAngle: -pi / 2,
            endAngle: 2 * pi * percent,
            colors: AppColors.primaryGradientColors,
          ).createShader(rect)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -pi / 2, 2 * pi * percent, false, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
