import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class AffirmationScreen extends StatefulWidget {
  static String routeName = 'affirmation-screen';
  static String routePath = '/affirmation-screen';
  const AffirmationScreen({super.key});

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> topCloudAnim;
  late Animation<double> bottomGreenAnim;
  late Animation<double> redBackAnim;
  late Animation<double> leftLeafAnim;
  late Animation<double> rightLeafAnim;
  late Animation<double> rainbowAnim;
  late Animation<double> centerBoyAnim;
  late Animation<double> rainbowLiftAnim;
  late Animation<double> textAnim;
  late Animation<double> text2Anim;
  late Animation<double> rainbowExitAnim;
  late Animation<double> topCloudExitAnim;
  late Animation<double> rightLeafExitAnim;
  late Animation<double> centerBoyExitAnim;
  late Animation<double> textExitAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 12),
    );

    bottomGreenAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.2, curve: Curves.easeOutBack),
    );
    topCloudAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.3, curve: Curves.easeIn),
    );
    redBackAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.3, curve: Curves.easeOutBack),
    );
    leftLeafAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.3, curve: Curves.easeOutBack),
    );
    rightLeafAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.3, curve: Curves.easeOutBack),
    );
    rainbowAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.3, curve: Curves.easeOutBack),
    );
    centerBoyAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1, 0.3, curve: Curves.easeOutBack),
    );
    rainbowLiftAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 0.6, curve: Curves.easeOut),
    );
    textAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.6, 0.8, curve: Curves.fastOutSlowIn),
    );

    textExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.8, 0.9, curve: Curves.easeIn),
    );
    text2Anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn),
    );
    rainbowExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.8, 1.0, curve: Curves.easeIn),
    );

    topCloudExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.9, 1.0, curve: Curves.easeIn),
    );
    rightLeafExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.9, 1.0, curve: Curves.easeIn),
    );

    centerBoyExitAnim = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.9, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HexColor('#9D9FE6').withOpacity(0.1),
              HexColor('#FFFFFF').withOpacity(0.1),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: SvgPicture.asset(Assets.vectors.affirStarBack)),

            // Top Cloud
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryOffset =
                    (1 - topCloudAnim.value) * size.height * 0.15;
                final exitOffset = topCloudExitAnim.value * size.height * 0.2;

                final totalOffset = entryOffset + exitOffset;

                return Positioned(top: -totalOffset, right: 0, child: child!);
              },
              child: Image.asset(Assets.vectors.affirTopRightCloud.path),
            ),

            // Bottom Green
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = (1 - bottomGreenAnim.value) * size.height * 0.15;
                return Positioned(
                  bottom: -offset,
                  left: 0,
                  right: 0,
                  child: child!,
                );
              },
              child: Image.asset(Assets.vectors.affirGreenBottom.path),
            ),

            // Red Background
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = redBackAnim.value.clamp(0.0, 1.0);
                final offset = (1 - redBackAnim.value) * size.width * 0.15;
                return Positioned(
                  left: 0,
                  right: -offset,
                  bottom: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: Image.asset(Assets.vectors.affirRedBackg.path),
            ),

            // Bottom Left Leafs
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = leftLeafAnim.value.clamp(0.0, 1.0);
                final offset = (1 - leftLeafAnim.value) * size.width * 0.15;
                return Positioned(
                  bottom: 0,
                  left: -offset,
                  right: 0,
                  child: Opacity(opacity: opacity, child: child!),
                );
              },
              child: SvgPicture.asset(Assets.vectors.affirBottomLeftLeafs),
            ),

            // Bottom Right Leafs
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final entryOffset =
                    (1 - rightLeafAnim.value) * size.width * 0.15;
                final exitOffset = rightLeafExitAnim.value * size.width * 0.3;
                final totalOffset = entryOffset + exitOffset;

                return Positioned(
                  bottom: 0,
                  right: -totalOffset,
                  left: 0,
                  child: Opacity(
                    opacity: 1 - rightLeafExitAnim.value,
                    child: child!,
                  ),
                );
              },
              child: SvgPicture.asset(Assets.vectors.affirRightBottomLeafs),
            ),

            // Rainbow
            // Rainbow
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final initialOffset =
                    (1 - rainbowAnim.value) * size.height * 0.9;
                final liftOffset = -20 * rainbowLiftAnim.value;
                final exitOffset = rainbowExitAnim.value * size.height * 0.5;

                final totalOffset = initialOffset + liftOffset - exitOffset;

                final scale = 0.95 + 0.1 * rainbowAnim.value;
                final leftOffset = -200.0 * rainbowLiftAnim.value;

                return Positioned(
                  bottom: -totalOffset,
                  left: leftOffset,
                  right: 0,
                  child: Transform.scale(scale: scale, child: child!),
                );
              },
              child: SvgPicture.asset(
                Assets.vectors.affirRainbow,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),

            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double start = -size.height;
                final double end = 75.0;
                final double entryBottom =
                    start + (end - start) * centerBoyAnim.value;

                // Add exit: move down by 300px when exiting
                final double exitOffset =
                    centerBoyExitAnim.value * size.height * 0.5;

                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: entryBottom - exitOffset,
                  child: Opacity(
                    opacity: 1 - centerBoyExitAnim.value,
                    child: child!,
                  ),
                );
              },
              child: SizedBox(
                width: 160,
                height: 300,
                child: Image.asset(
                  Assets.vectors.centerBoy1.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = textAnim.value * (1 - textExitAnim.value);

                final double start = size.height * 0.35;
                final double end = size.height * 0.4;

                final double entryOffset =
                    (textAnim.value) * (end - start) + start;

                // Move it upward during exit
                final double exitOffset = textExitAnim.value * 60;

                return Positioned(
                  top: entryOffset - exitOffset,

                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: Duration(milliseconds: 500),
                    child: child!,
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: size.width,
                child: Text(
                  'Hi Tom!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
            ),

            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = text2Anim.value;
                final offset = size.height * 0.4;

                return Positioned(
                  top: offset,
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: Duration(milliseconds: 300),
                    child: child!,
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: size.width,
                child: Text(
                  'Let’s do a affirmation',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
