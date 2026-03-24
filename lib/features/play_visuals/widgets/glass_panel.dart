import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';

/// Frosted-glass bottom sheet that collapses/expands via drag.
///
/// When [sessionStarted] is false the panel shows [titleSection].
/// After playback starts it cross-fades to [activeContent] (lyrics/yoga text)
/// and reveals [progressSection] + [controlSection].
class GlassBottomPanel extends StatelessWidget {
  const GlassBottomPanel({
    super.key,
    required this.safeBottom,
    required this.panelRevealAnimation,
    required this.sessionStarted,
    required this.panelValue,
    required this.titleSection,
    required this.activeContent,
    required this.progressSection,
    required this.controlSection,
    this.onDragUpdate,
    this.onDragEnd,
    this.onGripTap,
  });

  final double safeBottom;
  final Animation<double> panelRevealAnimation;
  final bool sessionStarted;
  final double panelValue;
  final Widget titleSection;
  final Widget activeContent;
  final Widget progressSection;
  final Widget controlSection;
  final GestureDragUpdateCallback? onDragUpdate;
  final GestureDragEndCallback? onDragEnd;
  final VoidCallback? onGripTap;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(32);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(8, 10, 8, safeBottom + 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: radius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                Colors.white.withValues(alpha: 0.10),
                Colors.white.withValues(alpha: 0.04),
                Colors.black.withValues(alpha: 0.10),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.30),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DragGrip(
                sessionStarted: sessionStarted,
                panelValue: panelValue,
                onDragUpdate: onDragUpdate,
                onDragEnd: onDragEnd,
                onTap: onGripTap,
              ),
              SizeTransition(
                sizeFactor: panelRevealAnimation,
                axis: Axis.vertical,
                axisAlignment: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedCrossFade(
                      firstChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: titleSection,
                      ),
                      secondChild: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 100),
                          child: SizedBox(
                            width: double.infinity,
                            child: activeContent,
                          ),
                        ),
                      ),
                      crossFadeState: sessionStarted
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 400),
                      sizeCurve: Curves.easeOut,
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: sessionStarted ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: sessionStarted
                      ? progressSection
                      : const SizedBox.shrink(),
                ),
              ),
              SizeTransition(
                sizeFactor: panelRevealAnimation,
                axis: Axis.vertical,
                axisAlignment: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Space.h4, controlSection],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragGrip extends StatelessWidget {
  const _DragGrip({
    required this.sessionStarted,
    required this.panelValue,
    this.onDragUpdate,
    this.onDragEnd,
    this.onTap,
  });

  final bool sessionStarted;
  final double panelValue;
  final GestureDragUpdateCallback? onDragUpdate;
  final GestureDragEndCallback? onDragEnd;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: sessionStarted ? onDragUpdate : null,
      onVerticalDragEnd: sessionStarted ? onDragEnd : null,
      onTap: sessionStarted && panelValue < 0.22 ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 10),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
