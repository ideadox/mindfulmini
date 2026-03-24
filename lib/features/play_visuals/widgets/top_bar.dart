import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayVisualsTopBar extends StatelessWidget {
  const PlayVisualsTopBar({
    super.key,
    required this.safeTop,
    required this.onBack,
    required this.favouriteAsset,
    this.onFavourite,
  });

  final double safeTop;
  final VoidCallback onBack;
  final String favouriteAsset;
  final VoidCallback? onFavourite;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: safeTop + 8,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LiquidGlassCircleButton(
            onPressed: onBack,
            icon: Icons.keyboard_arrow_down_rounded,
          ),
          _LiquidGlassCircleButton(
            onPressed: onFavourite ?? () {},
            iconAsset: favouriteAsset,
          ),
        ],
      ),
    );
  }
}

/// Frosted-glass circle button.
/// ClipRRect with borderRadius for smooth anti-aliased edges (smoother than ClipOval).
/// Single 1.5px white border — no foregroundDecoration double-edge.
class _LiquidGlassCircleButton extends StatelessWidget {
  const _LiquidGlassCircleButton({
    this.onPressed,
    this.icon,
    this.iconAsset,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? iconAsset;

  static const double _size = 44;
  static final _radius = BorderRadius.circular(_size / 2);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            borderRadius: _radius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.32),
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.50),
              width: 1.5,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            icon: icon != null
                ? Icon(
                    icon,
                    size: 24,
                    color: Colors.white.withValues(alpha: 0.95),
                  )
                : SvgPicture.asset(
                    iconAsset!,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withValues(alpha: 0.95),
                      BlendMode.srcIn,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
