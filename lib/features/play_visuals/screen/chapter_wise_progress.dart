import 'package:flutter/material.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';

import '../../../common/models/story_segment.dart';

/// Apple Music-style synced lyrics view.
///
/// Shows 5 visible lines: 2 previous (faded), the active line (bold/bright),
/// and 2 upcoming (faded). The active line smoothly scrolls into position as
/// the audio progresses. Works with both plain-text [StorySegment] (CMS) and
/// rich-text [YogaSegment] (yoga) content.
class LyricLineBuilder extends StatelessWidget {
  final List<StorySegment> segments;
  final List<YogaSegment> yogaSegments;
  final Duration currentPosition;
  final Duration totalDuration;
  final Color activeColor;
  final Color inactiveColor;

  const LyricLineBuilder({
    super.key,
    this.segments = const [],
    this.yogaSegments = const [],
    required this.currentPosition,
    required this.totalDuration,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final textLines = _buildTextLines();
    if (textLines.isEmpty) return const SizedBox.shrink();

    final audioTotalMs = totalDuration.inMilliseconds;
    if (audioTotalMs <= 0) return const SizedBox.shrink();

    final currentIndex = _getActiveIndex(textLines, audioTotalMs);

    return _LyricsStack(
      lines: textLines,
      activeIndex: currentIndex,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }

  /// Flattens segments into displayable text lines (skipping empty/break ones).
  List<_LyricLine> _buildTextLines() {
    // CMS path — plain text
    if (segments.isNotEmpty) {
      final lines = <_LyricLine>[];
      for (int i = 0; i < segments.length; i++) {
        if (segments[i].text.isNotEmpty) {
          lines.add(_LyricLine(
            plainText: segments[i].text,
            weight: segments[i].text.length.clamp(5, 99999).toDouble(),
            sourceIndex: i,
          ));
        } else {
          // Break segment — add weight to previous line or skip
          final breakWeight =
              (segments[i].delay.inMilliseconds / 70.0).clamp(1.0, 99999.0);
          if (lines.isNotEmpty) {
            lines.last = lines.last.copyWithExtraWeight(breakWeight);
          }
        }
      }
      return lines;
    }

    // Yoga path — rich text
    if (yogaSegments.isNotEmpty) {
      return yogaSegments.asMap().entries.map((e) {
        return _LyricLine(
          textSpans: e.value.textSpans,
          weight: e.value.charCount.clamp(5, 99999).toDouble(),
          sourceIndex: e.key,
        );
      }).toList();
    }

    return [];
  }

  int _getActiveIndex(List<_LyricLine> lines, int audioTotalMs) {
    final fraction =
        (currentPosition.inMilliseconds / audioTotalMs).clamp(0.0, 1.0);
    final totalWeight = lines.fold<double>(0, (a, b) => a + b.weight);
    if (totalWeight == 0) return 0;

    double cumulative = 0;
    for (int i = 0; i < lines.length; i++) {
      cumulative += lines[i].weight;
      if (fraction <= cumulative / totalWeight) {
        return i;
      }
    }
    return lines.length - 1;
  }
}

/// Internal model for a displayable lyric line.
class _LyricLine {
  final String? plainText;
  final List<YogaTextSpan>? textSpans;
  final double weight;
  final int sourceIndex;

  const _LyricLine({
    this.plainText,
    this.textSpans,
    required this.weight,
    required this.sourceIndex,
  });

  _LyricLine copyWithExtraWeight(double extra) => _LyricLine(
        plainText: plainText,
        textSpans: textSpans,
        weight: weight + extra,
        sourceIndex: sourceIndex,
      );

  String get displayText =>
      plainText ?? textSpans?.map((s) => s.text).join() ?? '';
}

/// Renders 5 lines with the active line prominent and surrounding lines faded.
class _LyricsStack extends StatelessWidget {
  final List<_LyricLine> lines;
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;

  const _LyricsStack({
    required this.lines,
    required this.activeIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    // Show 1 before + active + 1 after = 3 lines
    const int surroundCount = 1;

    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Column(
          key: ValueKey(activeIndex),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(surroundCount * 2 + 1, (i) {
            final lineIndex = activeIndex - surroundCount + i;
            final isActive = lineIndex == activeIndex;

            final double opacity = isActive ? 1.0 : 0.3;
            final double fontSize = isActive ? 24 : 18;
            final fontWeight =
                isActive ? FontWeight.w700 : FontWeight.w500;
            final color = isActive ? activeColor : inactiveColor;

            // Out of range — invisible spacer to maintain layout
            if (lineIndex < 0 || lineIndex >= lines.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(height: fontSize * 1.4),
              );
            }

            final line = lines[lineIndex];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Opacity(
                opacity: opacity,
                child: line.textSpans != null
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: line.textSpans!.map((span) {
                            return TextSpan(
                              text: span.text,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: fontWeight,
                                color: color,
                                height: 1.4,
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Text(
                        line.displayText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          color: color,
                          height: 1.4,
                        ),
                      ),
            ),
          );
          }),
        ),
      ),
    );
  }
}
