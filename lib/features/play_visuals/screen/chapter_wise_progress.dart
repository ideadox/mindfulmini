import 'package:flutter/material.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';

import '../../../common/models/audio_timings.dart';
import '../../../common/models/story_segment.dart';

/// Apple Music / Instagram-style synced lyrics view.
///
/// Shows the active line prominently with surrounding context lines faded.
/// Lines slide upward smoothly as the audio progresses, mimicking the
/// lyric scroll in Apple Music and Instagram stories.
class LyricLineBuilder extends StatelessWidget {
  final List<StorySegment> segments;
  final List<YogaSegment> yogaSegments;
  final Duration currentPosition;
  final Duration totalDuration;
  final Color activeColor;
  final Color inactiveColor;

  /// When present, the view advances lines using the end time of the last
  /// visible character in each chunk instead of proportional weights. This
  /// produces karaoke-grade sync and stays correct across authored `<break>`
  /// pauses and audio-speed changes.
  final AudioTimings? timings;

  const LyricLineBuilder({
    super.key,
    this.segments = const [],
    this.yogaSegments = const [],
    required this.currentPosition,
    required this.totalDuration,
    required this.activeColor,
    required this.inactiveColor,
    this.timings,
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

  // Max characters per displayed chunk (~2 lines at 22px on most screens).
  static const int _maxChunkChars = 70;

  /// Flattens segments into displayable text lines, splitting long ones
  /// into ~2-line chunks so that audio sync advances through each piece.
  /// When [timings] is present, each line additionally carries the audio
  /// start time of its first visible character — that drives activation so
  /// a line stays visible across any trailing silence until the next line
  /// is actually spoken.
  List<_LyricLine> _buildTextLines() {
    final cursor = <int>[0]; // mutable single-element cursor for timings lookup

    int? lookupStartMs(String chunk) {
      final t = timings;
      if (t == null) return null;
      return t.startMsForSubstring(chunk, fromIndex: cursor[0], cursorOut: cursor);
    }

    // CMS path — plain text
    if (segments.isNotEmpty) {
      final lines = <_LyricLine>[];
      for (int i = 0; i < segments.length; i++) {
        if (segments[i].text.isNotEmpty) {
          final chunks = _splitAtWordBoundary(segments[i].text, _maxChunkChars);
          for (final chunk in chunks) {
            lines.add(_LyricLine(
              plainText: chunk,
              weight: chunk.length.clamp(5, 99999).toDouble(),
              sourceIndex: i,
              startMs: lookupStartMs(chunk),
            ));
          }
        } else {
          // Break segment — fold into the previous line's *weight* for the
          // fallback path. With real timings, the break is implicit in the
          // gap between this line's startMs and the next line's startMs,
          // so no further adjustment is needed.
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
      final lines = <_LyricLine>[];
      for (int i = 0; i < yogaSegments.length; i++) {
        final fullText = yogaSegments[i].textSpans.map((s) => s.text).join();
        if (fullText.length <= _maxChunkChars) {
          lines.add(_LyricLine(
            textSpans: yogaSegments[i].textSpans,
            weight: yogaSegments[i].charCount.clamp(5, 99999).toDouble(),
            sourceIndex: i,
            startMs: lookupStartMs(fullText),
          ));
        } else {
          // Split the plain text and create simple text lines
          final chunks = _splitAtWordBoundary(fullText, _maxChunkChars);
          for (final chunk in chunks) {
            lines.add(_LyricLine(
              plainText: chunk,
              weight: chunk.length.clamp(5, 99999).toDouble(),
              sourceIndex: i,
              startMs: lookupStartMs(chunk),
            ));
          }
        }
      }
      return lines;
    }

    return [];
  }

  /// Splits [text] into chunks of roughly [maxChars], breaking at word
  /// boundaries so words are never cut in half.
  static List<String> _splitAtWordBoundary(String text, int maxChars) {
    if (text.length <= maxChars) return [text];

    final chunks = <String>[];
    final words = text.split(RegExp(r'\s+'));
    final buffer = StringBuffer();

    for (final word in words) {
      if (buffer.isEmpty) {
        buffer.write(word);
      } else if (buffer.length + 1 + word.length <= maxChars) {
        buffer.write(' $word');
      } else {
        chunks.add(buffer.toString());
        buffer.clear();
        buffer.write(word);
      }
    }
    if (buffer.isNotEmpty) chunks.add(buffer.toString());
    return chunks;
  }

  int _getActiveIndex(List<_LyricLine> lines, int audioTotalMs) {
    // Prefer real timestamps when every line has one.
    final allTimed = lines.every((l) => l.startMs != null);
    if (allTimed && lines.isNotEmpty) {
      final nowMs = currentPosition.inMilliseconds;
      // The active line is the last one whose startMs has already been
      // reached. This keeps the current line visible through any silence
      // that follows (e.g. authored `<break>` pauses) until the next line
      // actually begins speaking.
      int active = 0;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].startMs! <= nowMs) {
          active = i;
        } else {
          break;
        }
      }
      return active;
    }

    // Fallback: weight-proportional sync for legacy content.
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

  /// Audio start time (ms) of this line's first visible character.
  /// Populated only when [LyricLineBuilder.timings] was available at build
  /// time; drives line activation in the timestamp-sync path.
  final int? startMs;

  const _LyricLine({
    this.plainText,
    this.textSpans,
    required this.weight,
    required this.sourceIndex,
    this.startMs,
  });

  _LyricLine copyWithExtraWeight(double extra) => _LyricLine(
        plainText: plainText,
        textSpans: textSpans,
        weight: weight + extra,
        sourceIndex: sourceIndex,
        startMs: startMs,
      );

  String get displayText =>
      plainText ?? textSpans?.map((s) => s.text).join() ?? '';
}

/// Renders lyrics with smooth slide-up animation like Apple Music / Instagram.
class _LyricsStack extends StatefulWidget {
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
  State<_LyricsStack> createState() => _LyricsStackState();
}

class _LyricsStackState extends State<_LyricsStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int _displayedIndex = 0;
  int _previousIndex = 0;

  // Show 1 before + active + 1 after = 3 visible lines
  static const int _surroundCount = 1;
  static const int _maxTextLines = 3;

  @override
  void initState() {
    super.initState();
    _displayedIndex = widget.activeIndex;
    _previousIndex = widget.activeIndex;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant _LyricsStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeIndex != _displayedIndex) {
      _previousIndex = _displayedIndex;
      _displayedIndex = widget.activeIndex;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _slideAnimation.value;
        final fade = _fadeAnimation.value;

        return ClipRect(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_surroundCount * 2 + 1, (i) {
              final targetLineIndex = _displayedIndex - _surroundCount + i;

              final isTransitioning = _controller.isAnimating;
              final lineIndex = targetLineIndex;
              final isActive = lineIndex == _displayedIndex;

              // Slide offset: lines move up as new active line arrives
              final slideOffset = _previousIndex != _displayedIndex
                  ? Offset(
                      0,
                      (1 - t) *
                          (_displayedIndex > _previousIndex ? 0.3 : -0.3),
                    )
                  : Offset.zero;

              // Opacity: active line fades in, others crossfade
              double opacity;
              if (isActive) {
                opacity = isTransitioning ? fade : 1.0;
              } else {
                opacity = 0.35;
              }

              // Out of range — invisible spacer
              if (lineIndex < 0 || lineIndex >= widget.lines.length) {
                return _buildSpacer(isActive ? 22.0 : 17.0);
              }

              final line = widget.lines[lineIndex];

              return SlideTransition(
                position: AlwaysStoppedAnimation(slideOffset),
                child: _buildLineWidget(
                  line: line,
                  isActive: isActive,
                  opacity: opacity,
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildSpacer(double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(height: fontSize * 1.4),
    );
  }

  Widget _buildLineWidget({
    required _LyricLine line,
    required bool isActive,
    required double opacity,
  }) {
    final double fontSize = isActive ? 22 : 17;
    final fontWeight = isActive ? FontWeight.w700 : FontWeight.w500;
    final color = isActive ? widget.activeColor : widget.inactiveColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 350),
        child: line.textSpans != null
            ? RichText(
                textAlign: TextAlign.left,
                maxLines: _maxTextLines,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: line.textSpans!.map((span) {
                    return TextSpan(
                      text: span.text,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: span.isBold ? FontWeight.w800 : fontWeight,
                        fontStyle:
                            span.isItalic ? FontStyle.italic : FontStyle.normal,
                        color: color,
                        height: 1.35,
                      ),
                    );
                  }).toList(),
                ),
              )
            : Text(
                line.displayText,
                textAlign: TextAlign.left,
                maxLines: _maxTextLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: color,
                  height: 1.35,
                ),
              ),
      ),
    );
  }
}
