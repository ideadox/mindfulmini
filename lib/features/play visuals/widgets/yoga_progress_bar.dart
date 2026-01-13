import 'package:flutter/material.dart';

class YogaProgressBar extends StatefulWidget {
  final Duration totalDuration;
  final Duration currentPosition;
  final ValueChanged<Duration>? onSeek;
  final Color backgroundColor;
  final Color progressColor;
  final Color thumbColor;
  final double height;

  const YogaProgressBar({
    super.key,
    required this.totalDuration,
    required this.currentPosition,
    this.onSeek,
    this.backgroundColor = const Color(0xFFE8E8E8),
    this.progressColor = const Color(0xFF7C3AED),
    this.thumbColor = const Color(0xFF7C3AED),
    this.height = 4.0,
  });

  @override
  State<YogaProgressBar> createState() => _YogaProgressBarState();
}

class _YogaProgressBarState extends State<YogaProgressBar> {
  late SliderThemeData _sliderTheme;

  @override
  void initState() {
    super.initState();
    _sliderTheme = SliderThemeData(
      trackHeight: widget.height,
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: 8.0,
        elevation: 4.0,
      ),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
      activeTrackColor: widget.progressColor,
      inactiveTrackColor: widget.backgroundColor,
      thumbColor: widget.thumbColor,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressPercent =
        widget.totalDuration.inMilliseconds > 0
            ? widget.currentPosition.inMilliseconds /
                widget.totalDuration.inMilliseconds
            : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SliderTheme(
          data: _sliderTheme,
          child: Slider(
            value: progressPercent.clamp(0.0, 1.0),
            onChanged: (value) {
              final newDuration = Duration(
                milliseconds:
                    (value * widget.totalDuration.inMilliseconds).toInt(),
              );
              widget.onSeek?.call(newDuration);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(widget.currentPosition),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(
                _formatDuration(widget.totalDuration),
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
