import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/play_visuals/widgets/glass_styles.dart';

/// Seek-able progress slider with time labels.
///
/// When [minimalTransport] is true (panel collapsed), a compact liquid-glass
/// play/pause button is prepended so playback can still be controlled.
class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    super.key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onSeek,
    this.minimalTransport = false,
    this.isPlaying = false,
    this.onPlayPause,
  });

  final Duration currentPosition;
  final Duration totalDuration;
  final ValueChanged<Duration> onSeek;
  final bool minimalTransport;
  final bool isPlaying;
  final VoidCallback? onPlayPause;

  static final _sliderTheme = SliderThemeData(
    trackHeight: 6,
    trackShape: const RoundedRectSliderTrackShape(),
    thumbShape: const RoundSliderThumbShape(
      enabledThumbRadius: 8,
      elevation: 4,
    ),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: Colors.white.withValues(alpha: 0.28),
    thumbColor: Colors.white,
    overlayColor: Colors.white.withValues(alpha: 0.2),
  );

  @override
  Widget build(BuildContext context) {
    final progress = totalDuration.inMilliseconds > 0
        ? (currentPosition.inMilliseconds / totalDuration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    final sliderBlock = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: _sliderTheme,
          child: Slider(
            value: progress,
            onChanged: (value) {
              onSeek(
                Duration(
                  milliseconds:
                      (value * totalDuration.inMilliseconds).toInt(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                GlassStyles.formatDuration(currentPosition),
                style: GlassStyles.timeStyle,
              ),
              Text(
                GlassStyles.formatDuration(totalDuration),
                style: GlassStyles.timeStyle,
              ),
            ],
          ),
        ),
      ],
    );

    if (!minimalTransport || onPlayPause == null) return sliderBlock;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LiquidGlassMiniPlayPause(isPlaying: isPlaying, onTap: onPlayPause!),
        const SizedBox(width: 8),
        Expanded(child: sliderBlock),
      ],
    );
  }
}

/// Compact liquid-glass play/pause shown when the panel is collapsed.
class _LiquidGlassMiniPlayPause extends StatelessWidget {
  const _LiquidGlassMiniPlayPause({
    required this.isPlaying,
    required this.onTap,
  });

  final bool isPlaying;
  final VoidCallback onTap;

  static const double _size = 44;
  static final _radius = BorderRadius.circular(_size / 2);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: _radius,
            child: Container(
              width: _size,
              height: _size,
              alignment: Alignment.center,
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
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white.withValues(alpha: 0.95),
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
