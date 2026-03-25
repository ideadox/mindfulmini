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
    this.onHeart,
    this.isFavorited = false,
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
  final VoidCallback? onHeart;
  final bool isFavorited;
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
              child: _HeartButton(
                assetPath: heartAsset!,
                isFavorited: isFavorited,
                onPressed: onHeart,
              ),
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

/// Heart button with animated toggle between outline and filled states.
class _HeartButton extends StatefulWidget {
  const _HeartButton({
    required this.assetPath,
    required this.isFavorited,
    this.onPressed,
  });

  final String assetPath;
  final bool isFavorited;
  final VoidCallback? onPressed;

  @override
  State<_HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<_HeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(covariant _HeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorited != widget.isFavorited) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _bounceAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.isFavorited
                    ? [
                        Colors.red.withValues(alpha: 0.45),
                        Colors.red.withValues(alpha: 0.20),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.32),
                        Colors.white.withValues(alpha: 0.08),
                      ],
              ),
              border: Border.all(
                color: widget.isFavorited
                    ? Colors.red.withValues(alpha: 0.60)
                    : Colors.white.withValues(alpha: 0.50),
                width: 1.5,
              ),
            ),
            child: IconButton(
              onPressed: widget.onPressed ?? () {},
              padding: EdgeInsets.zero,
              icon: widget.isFavorited
                  ? const Icon(Icons.favorite_rounded, size: 20, color: Colors.red)
                  : SvgPicture.asset(
                      widget.assetPath,
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
      ),
    );
  }
}
