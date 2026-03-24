import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/core/app_colors.dart';

/// Row of playback controls: repeat, back-10, play/pause, forward-10, heart.
///
/// Secondary actions animate in once [sessionStarted] becomes true.
class MediaControls extends StatelessWidget {
  const MediaControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.sessionStarted,
    this.onBack10,
    this.onForward10,
    this.repeatAsset,
    this.back10Asset,
    this.forward10Asset,
    this.heartAsset,
    this.playPulseAnimation,
  });

  final bool isPlaying;
  final VoidCallback onPlayPause;
  final bool sessionStarted;
  final VoidCallback? onBack10;
  final VoidCallback? onForward10;
  final String? repeatAsset;
  final String? back10Asset;
  final String? forward10Asset;
  final String? heartAsset;
  final Animation<double>? playPulseAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (repeatAsset != null)
            _AnimatedAction(
              visible: sessionStarted,
              padding: const EdgeInsets.only(right: 12),
              child: LiquidGlassIconButton(assetPath: repeatAsset!),
            ),
          if (back10Asset != null)
            _AnimatedAction(
              visible: sessionStarted,
              padding: const EdgeInsets.only(right: 16),
              child: LiquidGlassIconButton(
                assetPath: back10Asset!,
                onPressed: onBack10,
              ),
            ),
          LiquidGlassPlayButton(
            isPlaying: isPlaying,
            onPressed: onPlayPause,
            pulseAnimation: !sessionStarted ? playPulseAnimation : null,
          ),
          if (forward10Asset != null)
            _AnimatedAction(
              visible: sessionStarted,
              padding: const EdgeInsets.only(left: 16),
              child: LiquidGlassIconButton(
                assetPath: forward10Asset!,
                onPressed: onForward10,
              ),
            ),
          if (heartAsset != null)
            _AnimatedAction(
              visible: sessionStarted,
              padding: const EdgeInsets.only(left: 12),
              child: LiquidGlassIconButton(assetPath: heartAsset!),
            ),
        ],
      ),
    );
  }
}

/// Primary play/pause — frosted glass circle tinted with the brand gradient.
class LiquidGlassPlayButton extends StatelessWidget {
  const LiquidGlassPlayButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
    this.pulseAnimation,
  });

  final bool isPlaying;
  final VoidCallback onPressed;
  final Animation<double>? pulseAnimation;

  static const double _size = 64;
  static final _radius = BorderRadius.circular(_size / 2);

  @override
  Widget build(BuildContext context) {
    Widget button = ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            borderRadius: _radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryGradientColors[2].withValues(alpha: 0.92),
                AppColors.primaryGradientColors[1].withValues(alpha: 0.82),
                AppColors.primaryGradientColors[0].withValues(alpha: 0.92),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                key: ValueKey(isPlaying),
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );

    if (pulseAnimation != null) {
      return ScaleTransition(scale: pulseAnimation!, child: button);
    }
    return button;
  }
}

/// Frosted-glass icon button (secondary actions).
/// ClipRRect for smooth anti-aliased edges. Single border, no foregroundDecoration.
class LiquidGlassIconButton extends StatelessWidget {
  const LiquidGlassIconButton({
    super.key,
    required this.assetPath,
    this.onPressed,
  });

  final String assetPath;
  final VoidCallback? onPressed;

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
            onPressed: onPressed ?? () {},
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              assetPath,
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

class _AnimatedAction extends StatelessWidget {
  const _AnimatedAction({
    required this.visible,
    required this.padding,
    required this.child,
  });

  final bool visible;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: visible
            ? Padding(padding: padding, child: child)
            : const SizedBox.shrink(),
      ),
    );
  }
}
