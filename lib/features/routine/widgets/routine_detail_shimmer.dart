import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';

/// Shimmer placeholder for the routine detail screen.
/// When [showHeader] is true, includes the top header row placeholder.
/// When false, only shows the activity-level placeholders (used for inner loading).
class RoutineDetailShimmer extends StatefulWidget {
  final bool showHeader;
  const RoutineDetailShimmer({super.key, this.showHeader = true});

  @override
  State<RoutineDetailShimmer> createState() => _RoutineDetailShimmerState();
}

class _RoutineDetailShimmerState extends State<RoutineDetailShimmer>
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

  Widget _shimmerBox(double width, double height, {double radius = 8, bool isCircle = false}) {
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
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildActivityLevelPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dots + line
          Column(
            children: List.generate(4, (i) {
              return Column(
                children: [
                  _shimmerBox(20, 20, isCircle: true),
                  if (i < 3) _shimmerBox(4, 70, radius: 2),
                ],
              );
            }),
          ),
          Space.w12,
          // Activity cards
          Expanded(
            child: Column(
              children: List.generate(4, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: i < 3 ? 16 : 0),
                  child: Container(
                    height: 72,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _shimmerBox(48, 48, radius: 12),
                        Space.w12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _shimmerBox(120, 14),
                              const SizedBox(height: 8),
                              _shimmerBox(80, 10),
                            ],
                          ),
                        ),
                        _shimmerBox(28, 28, isCircle: true),
                      ],
                    ),
                  ),
                );
              }),
            ),
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
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
            children: [
              if (widget.showHeader) ...[
                Space.h40,
                // Header row: back button + title + percentage circle
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      _shimmerBox(40, 40, isCircle: true),
                      Space.w12,
                      Expanded(
                        child: Column(
                          children: [
                            _shimmerBox(140, 16),
                            const SizedBox(height: 6),
                            _shimmerBox(100, 12),
                          ],
                        ),
                      ),
                      Space.w12,
                      _shimmerBox(48, 48, isCircle: true),
                    ],
                  ),
                ),
                Space.h20,
                // Horizontal calendar placeholder
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 7,
                    separatorBuilder: (_, __) => Space.w12,
                    itemBuilder: (_, __) {
                      return Column(
                        children: [
                          _shimmerBox(12, 12),
                          const SizedBox(height: 8),
                          _shimmerBox(40, 40, isCircle: true),
                        ],
                      );
                    },
                  ),
                ),
              ],
              Space.h20,
              // Activity level placeholders
              _buildActivityLevelPlaceholder(),
            ],
          ),
          ),
        );
      },
    );
  }
}
