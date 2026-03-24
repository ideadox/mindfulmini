import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/common/providers/speech_provider.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class CommonSpeechTextfield extends StatefulWidget {
  final String hintText;
  final int minLines;
  final int? maxLines;
  final SpeechProvider speechProvider;

  const CommonSpeechTextfield({
    super.key,
    required this.hintText,
    required this.speechProvider,
    this.minLines = 1,
    this.maxLines,
  });

  @override
  State<CommonSpeechTextfield> createState() => _CommonSpeechTextfieldState();
}

class _CommonSpeechTextfieldState extends State<CommonSpeechTextfield>
    with TickerProviderStateMixin {
  static const double _micInset = 10;
  static const double _micSize = 48;
  static const Duration _holdThreshold = Duration(milliseconds: 150);

  static const EdgeInsets _textPadding = EdgeInsets.fromLTRB(
    16,
    16,
    16,
    _micInset + _micSize + 6,
  );

  bool _showTooltip = false;
  bool _holding = false;
  bool _wantsStop = false;
  Timer? _holdTimer;

  /// Single controller for the mic button: 0 = idle, 1 = active.
  /// forward() fires on pointer-down (instant feedback).
  /// reverse() fires on pointer-up (smooth wind-down).
  /// All decoration, scale, and icon changes derive from this one value.
  late AnimationController _micAnim;
  late CurvedAnimation _micCurved;

  late AnimationController _pulseAnim;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  static final BoxDecoration _idleMicDecor = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white,
    border: Border.all(color: Colors.grey.shade400),
  );

  static final BoxDecoration _activeMicDecor = BoxDecoration(
    shape: BoxShape.circle,
    gradient: AppColors.primaryGradient,
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.35),
        blurRadius: 16,
        spreadRadius: 2,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();

    _micAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _micCurved = CurvedAnimation(
      parent: _micAnim,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _pulseAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseScale = Tween(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(parent: _pulseAnim, curve: Curves.easeOut),
    );
    _pulseOpacity = Tween(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _pulseAnim, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _micCurved.dispose();
    _micAnim.dispose();
    _pulseAnim.dispose();
    super.dispose();
  }

  // ── pointer handlers ──────────────────────────────────────────────

  void _onPointerDown(PointerDownEvent _) {
    _holdTimer?.cancel();
    _wantsStop = false;
    _micAnim.forward();
    setState(() => _showTooltip = false);

    _holdTimer = Timer(_holdThreshold, () {
      _holding = true;
      _startRecording();
    });
  }

  void _onPointerUp(PointerUpEvent _) {
    if (_holdTimer?.isActive ?? false) {
      _holdTimer!.cancel();
      _micAnim.reverse();
      _onQuickTap();
    } else if (_holding) {
      _holding = false;
      _stopRecording();
    } else {
      _micAnim.reverse();
    }
  }

  void _onPointerCancel(PointerCancelEvent _) {
    _holdTimer?.cancel();
    _micAnim.reverse();
    if (_holding) {
      _holding = false;
      _stopRecording();
    }
  }

  void _startRecording() {
    final provider = widget.speechProvider;
    if (!provider.isListening) {
      _wantsStop = false;
      provider.startListening();
      _pulseAnim.repeat();
    }
  }

  void _stopRecording() {
    final provider = widget.speechProvider;
    if (provider.isListening) {
      provider.stopListening();
    } else {
      _wantsStop = true;
    }
    _micAnim.reverse();
    _pulseAnim
      ..stop()
      ..reset();
  }

  void _onQuickTap() {
    if (widget.speechProvider.isListening) {
      _stopRecording();
      return;
    }
    setState(() => _showTooltip = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showTooltip = false);
    });
  }

  // ── build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.speechProvider,
      child: Consumer<SpeechProvider>(
        builder: (context, provider, _) {
          final isRecording = provider.isListening;

          if (_wantsStop && isRecording) {
            _wantsStop = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _stopRecording();
            });
          }

          if (!isRecording && (_pulseAnim.isAnimating || _micAnim.value > 0)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _micAnim.reverse();
              _pulseAnim
                ..stop()
                ..reset();
            });
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // ── text field ────────────────────────────────────────
              Theme(
                data: Theme.of(context).copyWith(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                child: TextFormField(
                  controller: provider.textController,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isRecording
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isRecording
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : AppColors.purple,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: _textPadding,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Please enter something.';
                    return null;
                  },
                  onChanged: (value) => provider.addToHistory(value),
                ),
              ),

              // ── "Listening…" badge ────────────────────────────────
              Positioned(
                bottom: _micInset + _micSize + 8,
                right: _micInset,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: isRecording ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedSlide(
                      offset:
                          isRecording ? Offset.zero : const Offset(0, 0.3),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _RecordingDot(),
                            const SizedBox(width: 6),
                            Text(
                              'Listening…',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── pulse ripple ──────────────────────────────────────
              Positioned(
                bottom: _micInset,
                right: _micInset,
                child: IgnorePointer(
                  child: SizedBox(
                    width: _micSize,
                    height: _micSize,
                    child: AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, _) {
                        if (!_pulseAnim.isAnimating && _pulseAnim.value == 0) {
                          return const SizedBox.shrink();
                        }
                        return Transform.scale(
                          scale: _pulseScale.value,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(
                                alpha: _pulseOpacity.value,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // ── mic button ────────────────────────────────────────
              Positioned(
                key: const ValueKey('mic-btn'),
                bottom: _micInset,
                right: _micInset,
                child: Listener(
                  onPointerDown: _onPointerDown,
                  onPointerUp: _onPointerUp,
                  onPointerCancel: _onPointerCancel,
                  child: AnimatedBuilder(
                    animation: _micCurved,
                    builder: (context, _) {
                      final t = _micCurved.value;
                      final scale = 1.0 + 0.2 * t;
                      final decor =
                          BoxDecoration.lerp(_idleMicDecor, _activeMicDecor, t)!;

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          height: _micSize,
                          width: _micSize,
                          decoration: decor,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity: (1.0 - t).clamp(0.0, 1.0),
                                  child: SvgPicture.asset(
                                    Assets.icons.mic,
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                                Opacity(
                                  opacity: t.clamp(0.0, 1.0),
                                  child: const Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ── tooltip ───────────────────────────────────────────
              if (_showTooltip)
                Positioned(
                  bottom: _micInset + _micSize + 8,
                  right: _micInset,
                  child: const _HoldToSpeakTooltip(),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ── helper widgets ──────────────────────────────────────────────────────

class _RecordingDot extends StatefulWidget {
  const _RecordingDot();

  @override
  State<_RecordingDot> createState() => _RecordingDotState();
}

class _RecordingDotState extends State<_RecordingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
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
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                Colors.red.withValues(alpha: 0.4 + 0.6 * _controller.value),
          ),
        );
      },
    );
  }
}

class _HoldToSpeakTooltip extends StatelessWidget {
  const _HoldToSpeakTooltip();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, color: Colors.white, size: 16),
            SizedBox(width: 6),
            Text(
              'Hold to speak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
