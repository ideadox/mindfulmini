import 'package:flutter/material.dart';

class IconFrameAnimator extends StatefulWidget {
  final List<Widget> icons;
  final Duration duration;

  const IconFrameAnimator({
    super.key,
    required this.icons,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<IconFrameAnimator> createState() => IconFrameAnimatorState();
}

class IconFrameAnimatorState extends State<IconFrameAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentFrame = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    )..addListener(() {
      setState(() {
        _currentFrame = (_animation.value * (widget.icons.length - 1)).floor();
      });
    });
  }

  void startAnimation() {
    if (_controller.isAnimating) return;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.icons[_currentFrame];
  }
}
