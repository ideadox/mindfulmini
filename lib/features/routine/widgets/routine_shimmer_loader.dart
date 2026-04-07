import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';

/// Shimmer placeholder that mimics the [MyroutineBriefCard] layout.
class RoutineShimmerLoader extends StatefulWidget {
  const RoutineShimmerLoader({super.key});

  @override
  State<RoutineShimmerLoader> createState() => _RoutineShimmerLoaderState();
}

class _RoutineShimmerLoaderState extends State<RoutineShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox(double width, double height, {double radius = 8}) {
    final position = _controller.value;
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(position * 2 - 1.3, 0),
          end: Alignment(position * 2 - 0.7, 0),
          colors: [Colors.grey[100]!, Colors.grey[50]!, Colors.grey[100]!],
        ).createShader(bounds);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  /// A single card placeholder matching the routine brief card shape.
  Widget _buildCardPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time-of-day row
          Row(
            children: [
              _shimmerBox(24, 24, radius: 12),
              Space.w8,
              _shimmerBox(80, 14),
            ],
          ),
          Space.h16,
          Row(
            children: [
              // Left side: duration + tags
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(100, 20),
                    const SizedBox(height: 6),
                    _shimmerBox(140, 12),
                    Space.h16,
                    _shimmerBox(180, 28, radius: 30),
                  ],
                ),
              ),
              // Right side: CTA button
              Expanded(
                flex: 1,
                child: _shimmerBox(double.infinity, 42, radius: 30),
              ),
            ],
          ),
          Space.h16,
          // Progress bar row
          Row(
            children: [
              Expanded(child: _shimmerBox(double.infinity, 8, radius: 4)),
              Space.w8,
              _shimmerBox(32, 14),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ListView.separated(
          padding: const EdgeInsets.only(
            top: 120,
            left: 12,
            right: 12,
            bottom: 12,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, __) => Space.h32,
          itemBuilder: (_, __) => _buildCardPlaceholder(),
        );
      },
    );
  }
}
