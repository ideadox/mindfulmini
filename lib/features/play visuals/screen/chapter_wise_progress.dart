import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'dart:async';

import 'package:mindfulminis/features/play%20visuals/models/audolyric.dart';

import '../../../common/models/story_segment.dart';

class AudioProgressWithLyrics extends StatefulWidget {
  final Duration totalDuration;
  final List<AudioChapter> chapterTimestamps;
  final List<LyricLine> lyrics;
  final VoidCallback? onComplete;

  const AudioProgressWithLyrics({
    super.key,
    required this.totalDuration,
    required this.chapterTimestamps,
    required this.lyrics,
    this.onComplete,
  });

  @override
  State<AudioProgressWithLyrics> createState() =>
      _AudioProgressWithLyricsState();
}

class _AudioProgressWithLyricsState extends State<AudioProgressWithLyrics> {
  Duration currentPosition = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate playback for demo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (currentPosition < widget.totalDuration) {
          currentPosition += const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          widget.onComplete?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get currentLyricIndex {
    for (int i = 0; i < widget.lyrics.length; i++) {
      final currentTime = widget.lyrics[i].timestamp;
      if (i + 1 < widget.lyrics.length) {
        final nextTime = widget.lyrics[i + 1].timestamp;
        if (currentPosition >= currentTime && currentPosition < nextTime) {
          return i;
        }
      } else {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final chapterWidths = _calculateChapterWidths();

    return Column(
      children: [
        Row(
          children: List.generate(widget.chapterTimestamps.length * 2 - 1, (i) {
            if (i.isOdd) return const SizedBox(width: 4);

            final index = i ~/ 2;
            final chapter = widget.chapterTimestamps[index];
            final isActive =
                currentPosition >= chapter.start &&
                currentPosition < chapter.end;
            final isCompleted = currentPosition >= chapter.end;

            // progress within current chapter (0.0 to 1.0)
            double progress = 0;
            if (isActive) {
              final chapterDuration = chapter.end - chapter.start;
              final elapsed = currentPosition - chapter.start;
              progress =
                  elapsed.inMilliseconds / chapterDuration.inMilliseconds;
            }

            return Expanded(
              flex: chapterWidths[index],
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final chapterWidth = constraints.maxWidth;

                  double indicatorLeft = 0;
                  if (isActive) {
                    final chapterDuration = chapter.end - chapter.start;
                    final elapsed = currentPosition - chapter.start;
                    final progress =
                        elapsed.inMilliseconds / chapterDuration.inMilliseconds;
                    indicatorLeft = chapterWidth * progress;
                  }

                  return SizedBox(
                    height: 20,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        if (isCompleted || isActive)
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor:
                                isCompleted
                                    ? 1.0
                                    : (indicatorLeft / chapterWidth).clamp(
                                      0.0,
                                      1.0,
                                    ),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                // gradient: AppColors.primaryGradient,
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        if (isActive)
                          Positioned(
                            left: indicatorLeft - 6,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                // gradient: AppColors.primaryGradient,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppFormate.formatDuration(currentPosition),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              AppFormate.formatDuration(widget.totalDuration),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  List<int> _calculateChapterWidths() {
    return widget.chapterTimestamps.map((chapter) {
      final segmentDuration = chapter.end - chapter.start;
      final flex =
          (segmentDuration.inMilliseconds /
                  widget.totalDuration.inMilliseconds *
                  100)
              .round();
      return flex;
    }).toList();
  }
}

class LyricLineBuilder extends StatefulWidget {
  final List<StorySegment> segments;

  const LyricLineBuilder({super.key, required this.segments});

  @override
  State<LyricLineBuilder> createState() => _LyricLineBuilderState();
}

class _LyricLineBuilderState extends State<LyricLineBuilder>
    with TickerProviderStateMixin {
  final List<String> shownLines = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    playNext();
  }

  void playNext() async {
    if (currentIndex >= widget.segments.length) return;

    final seg = widget.segments[currentIndex];

    if (seg.text.isNotEmpty) {
      setState(() => shownLines.add(seg.text));
    }

    await Future.delayed(seg.delay + const Duration(milliseconds: 800));
    currentIndex++;
    playNext();
  }

  @override
  Widget build(BuildContext context) {
    final currentLyric = shownLines.last;
    final currentLyricIndex = shownLines.length - 1;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(
        currentLyric,
        key: ValueKey(currentLyricIndex),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
