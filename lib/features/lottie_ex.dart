import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class LottieEx extends StatefulWidget {
  const LottieEx({super.key});

  @override
  State<LottieEx> createState() => _LottieExState();
}

class _LottieExState extends State<LottieEx>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _controller.forward(from: 0.0); // Play from start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Lottie.asset(
            fit: BoxFit.fill,
            Assets.vectors.flow146, // Your Lottie path
            controller: _controller,
            onLoaded: (composition) {
              _controller.duration = composition.duration;
            },
          ),
        ),
        ElevatedButton(
          onPressed: _playAnimation,
          child: Text("Play Animation"),
        ),
      ],
    ));
  }
}
