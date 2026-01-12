import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class YogaListShimmerLoader extends StatefulWidget {
  const YogaListShimmerLoader();

  @override
  State<YogaListShimmerLoader> createState() => _YogaListShimmerLoaderState();
}

class _YogaListShimmerLoaderState extends State<YogaListShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Space.h40,
              // Back button and title area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerBox(context, 40, 40),
                    _buildShimmerBox(context, 150, 24),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              Space.h20,
              // Image shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildShimmerBox(context, double.infinity, 250),
              ),
              Space.h20,
              // Stepper items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    _buildShimmerBox(context, double.infinity, 150),
                    Space.h16,
                    _buildShimmerBox(context, double.infinity, 150),
                    Space.h16,
                    _buildShimmerBox(context, double.infinity, 150),
                    Space.h16,
                    _buildShimmerBox(context, double.infinity, 150),
                    Space.h16,
                    _buildShimmerBox(context, double.infinity, 150),
                    Space.h16,
                    _buildShimmerBox(context, double.infinity, 150),
                  ],
                ),
              ),
              Space.h40,
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox(BuildContext context, double width, double height) {
    final position = _animationController.value;

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(position * 2 - 1.3, 0),
          end: Alignment(position * 2 - 0.7, 0),
          colors: [Colors.grey[300]!, Colors.grey[200]!, Colors.grey[300]!],
        ).createShader(bounds);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
