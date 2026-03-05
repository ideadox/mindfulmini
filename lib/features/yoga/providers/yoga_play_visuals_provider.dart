import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';

/// Independent provider for managing yoga content display in PlayVisualsCopy
class YogaPlayVisualsProvider with ChangeNotifier {
  final YogaContentModel yogaContent;
  final AudioPlayer audioPlayer = AudioPlayer();

  List<YogaSegment> _segments = [];
  Duration _totalDuration = Duration.zero;
  bool _isInitialized = false;
  bool _isDisposed = false;

  // Audio state
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration audioDuration = Duration.zero;

  // Stream subscriptions
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  YogaPlayVisualsProvider({required this.yogaContent}) {
    _initialize();
  }

  List<YogaSegment> get segments => _segments;
  Duration get totalDuration => audioDuration > Duration.zero ? audioDuration : _totalDuration;
  bool get isInitialized => _isInitialized;

  /// Initialize by parsing yoga content and setting up audio
  Future<void> _initialize() async {
    try {
      _segments = YogaRichTextParser.parseYogaContent(
        yogaContent.contentDescription,
      );

      // Calculate total duration from segments as fallback
      _totalDuration = Duration(
        milliseconds: _segments.fold<int>(
          0,
          (sum, segment) => sum + segment.duration.inMilliseconds,
        ),
      );

      // Initialize audio if available
      await _initializeAudio();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing YogaPlayVisualsProvider: $e');
      _isInitialized = false;
      notifyListeners();
    }
  }

  /// Initialize audio player with the yoga content's audio file
  Future<void> _initializeAudio() async {
    final audioFilename = yogaContent.audio?['filename'];
    if (audioFilename != null) {
      try {
        final audioUrl = '${ApiConstants.mediaBaseUrl}$audioFilename';
        await audioPlayer.setUrl(audioUrl);

        // Listen to player state changes
        _playerStateSubscription = audioPlayer.playerStateStream.listen((state) {
          if (!_isDisposed) {
            isPlaying = state.playing;
            notifyListeners();
          }
        });

        // Listen to position changes
        _positionSubscription = audioPlayer.positionStream.listen((position) {
          if (!_isDisposed) {
            currentPosition = position;
            notifyListeners();
          }
        });

        // Listen to duration changes
        _durationSubscription = audioPlayer.durationStream.listen((duration) {
          if (!_isDisposed && duration != null) {
            audioDuration = duration;
            notifyListeners();
          }
        });
      } catch (e) {
        print('Error initializing yoga audio: $e');
      }
    }
  }

  /// Play or pause audio
  Future<void> playPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    notifyListeners();
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  /// Seek forward 10 seconds
  Future<void> seekForward() async {
    final newPosition = currentPosition + const Duration(seconds: 10);
    final maxDuration = totalDuration;
    await seek(newPosition > maxDuration ? maxDuration : newPosition);
  }

  /// Seek backward 10 seconds
  Future<void> seekBackward() async {
    final newPosition = currentPosition - const Duration(seconds: 10);
    await seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  /// Get segment at specific index
  YogaSegment? getSegmentAt(int index) {
    if (index >= 0 && index < _segments.length) {
      return _segments[index];
    }
    return null;
  }

  /// Calculate the start time for a segment
  Duration getSegmentStartTime(int index) {
    Duration startTime = Duration.zero;
    for (int i = 0; i < index && i < _segments.length; i++) {
      startTime += _segments[i].duration;
    }
    return startTime;
  }

  /// Get next segment index based on elapsed time
  int getSegmentIndexForTime(Duration elapsedTime) {
    Duration currentTime = Duration.zero;
    for (int i = 0; i < _segments.length; i++) {
      currentTime += _segments[i].duration;
      if (elapsedTime < currentTime) {
        return i;
      }
    }
    return _segments.length - 1;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }
}
