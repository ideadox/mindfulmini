import 'package:flutter/material.dart';

/// Shared, pre-cached styles for the glass-panel play screen.
/// Using static finals avoids recreating objects on every build.
class GlassStyles {
  GlassStyles._();

  // ── Shadows ──

  static final List<Shadow> textShadows = [
    Shadow(
      color: Colors.black.withValues(alpha: 0.55),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
    Shadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  // ── Text Styles ──

  static final TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: Colors.white.withValues(alpha: 0.98),
    shadows: textShadows,
  );

  static final TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    height: 1.35,
    color: Colors.white.withValues(alpha: 0.78),
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.45),
        blurRadius: 8,
        offset: const Offset(0, 1),
      ),
    ],
  );

  static final TextStyle lyricStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: Colors.white.withValues(alpha: 0.97),
    shadows: textShadows,
  );

  static final TextStyle timeStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white.withValues(alpha: 0.82),
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 6,
        offset: const Offset(0, 1),
      ),
    ],
  );

  // ── Helpers ──

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
