import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/providers/speech_provider.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

class CommonSpeechTextfield extends StatefulWidget {
  final String hintText;
  final int minLines;
  final int maxLines;
  final SpeechProvider speechProvider;

  const CommonSpeechTextfield({
    super.key,
    required this.hintText,
    required this.speechProvider,
    this.minLines = 8,
    this.maxLines = 8,
  });

  @override
  State<CommonSpeechTextfield> createState() => _CommonSpeechTextfieldState();
}

class _CommonSpeechTextfieldState extends State<CommonSpeechTextfield>
    with SingleTickerProviderStateMixin {
  bool _showTooltip = false;

  void _onMicTap() {
    // Single tap → show tooltip hint
    if (!widget.speechProvider.isListening) {
      setState(() => _showTooltip = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showTooltip = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.speechProvider,
      child: Consumer<SpeechProvider>(
        builder: (context, provider, _) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Text field
              TextFormField(
                controller: provider.textController,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter something.';
                  }
                  return null;
                },
                onChanged: (value) {
                  provider.addToHistory(value);
                },
              ),

              // Recording overlay — shown when listening
              if (provider.isListening)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PulsingMicIcon(),
                        SizedBox(height: 14),
                        Text(
                          'Listening... speak now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Prominent "release to stop" chip
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                size: 16,
                                color: Colors.grey.shade700,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Release to stop recording',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom toolbar
              Positioned(
                bottom: 10,
                right: 10,
                left: 10,
                child: Row(
                  children: [
                    IconButton.outlined(
                      icon: SvgPicture.asset(Assets.icons.undo),
                      onPressed: provider.isListening
                          ? null
                          : () {
                              provider.undo();
                            },
                    ),
                    Space.w12,
                    IconButton.outlined(
                      icon: SvgPicture.asset(Assets.icons.redo),
                      onPressed: provider.isListening
                          ? null
                          : () {
                              provider.redo();
                            },
                    ),
                    Spacer(),
                    // Hold-to-speak mic button
                    GestureDetector(
                      onTap: _onMicTap,
                      onLongPressStart: (_) {
                        // Dismiss tooltip if it's showing
                        if (_showTooltip) {
                          setState(() => _showTooltip = false);
                        }
                        if (!provider.isListening) {
                          provider.startListening();
                        }
                      },
                      onLongPressEnd: (_) {
                        if (provider.isListening) {
                          provider.stopListening();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: provider.isListening
                              ? LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    HexColor('#6E40F9'),
                                    HexColor('#A569FB'),
                                    HexColor('#CE89FF'),
                                  ],
                                )
                              : null,
                          color: provider.isListening ? null : Colors.white,
                          border: provider.isListening
                              ? null
                              : Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: provider.isListening
                              ? Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : SvgPicture.asset(
                                  Assets.icons.mic,
                                  width: 22,
                                  height: 22,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // "Hold to speak" tooltip — appears on single tap
              if (_showTooltip)
                Positioned(
                  bottom: 64,
                  right: 10,
                  child: _HoldToSpeakTooltip(),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Tooltip bubble that tells the user to hold the mic.
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
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
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

/// A pulsing microphone icon for the recording overlay.
class _PulsingMicIcon extends StatefulWidget {
  const _PulsingMicIcon();

  @override
  State<_PulsingMicIcon> createState() => _PulsingMicIconState();
}

class _PulsingMicIconState extends State<_PulsingMicIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnim = Tween<double>(begin: 0.3, end: 0.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring
            Transform.scale(
              scale: _scaleAnim.value,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(
                    alpha: _opacityAnim.value,
                  ),
                ),
              ),
            ),
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Icon(Icons.mic, color: Colors.white, size: 28),
            ),
          ],
        );
      },
    );
  }
}
