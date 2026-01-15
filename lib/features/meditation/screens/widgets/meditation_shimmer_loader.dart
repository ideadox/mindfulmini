import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class MeditationShimmerLoader extends StatefulWidget {
  const MeditationShimmerLoader();

  @override
  State<MeditationShimmerLoader> createState() =>
      _MeditationShimmerLoaderState();
}

class _MeditationShimmerLoaderState extends State<MeditationShimmerLoader>
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
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            Assets.images.medatationTopBackground.path,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 50,
                      child: CustomBackButton(hasBackground: true),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _buildShimmerBox(context, 150, 24),
                      Space.h8,
                      _buildShimmerBox(context, double.infinity, 60),
                      Space.h12,
                      _buildShimmerBox(context, double.infinity, 200),
                      Space.h16,
                      _buildShimmerBox(context, double.infinity, 200),
                      Space.h16,
                      _buildShimmerBox(context, double.infinity, 200),
                      Space.h16,
                      _buildShimmerBox(context, double.infinity, 200),
                    ],
                  ),
                ),
              ],
            ),
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
