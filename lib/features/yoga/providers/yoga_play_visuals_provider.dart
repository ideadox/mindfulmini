import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';

class YogaPlayVisualsProvider with ChangeNotifier {
  final YogaContentModel yogaContent;
  final AudioPlayer audioPlayer = AudioPlayer();

  List<YogaSegment> _segments = [];
  Duration _totalDuration = Duration.zero;
  bool _isInitialized = false;
  bool _isDisposed = false;

  bool isPlaying = false;
  bool audioReady = false;
  Duration currentPosition = Duration.zero;
  Duration audioDuration = Duration.zero;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  YogaPlayVisualsProvider({required this.yogaContent}) {
    _initialize();
  }

  List<YogaSegment> get segments => _segments;
  Duration get totalDuration =>
      audioDuration > Duration.zero ? audioDuration : _totalDuration;
  bool get isInitialized => _isInitialized;

  Future<void> _initialize() async {
    try {
      _segments = YogaRichTextParser.parseYogaContent(
        yogaContent.contentDescription,
      );

      _totalDuration = Duration(
        milliseconds: _segments.fold<int>(
          0,
          (sum, segment) => sum + segment.duration.inMilliseconds,
        ),
      );

      await _initializeAudio();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      log('YogaPlayVisualsProvider: init failed – $e');
      _isInitialized = false;
      notifyListeners();
    }
  }

  Future<void> _initializeAudio() async {
    final audioFilename = yogaContent.audio?['filename'];
    if (audioFilename == null) return;

    try {
      final audioUrl = '${ApiConstants.mediaBaseUrl}$audioFilename';
      await audioPlayer.setUrl(audioUrl);

      _playerStateSubscription =
          audioPlayer.playerStateStream.listen((state) {
        if (_isDisposed) return;
        final wasPlaying = isPlaying;
        isPlaying = state.playing;

        if (state.processingState == ProcessingState.completed) {
          isPlaying = false;
        }

        if (wasPlaying != isPlaying) notifyListeners();
      });

      _positionSubscription = audioPlayer.positionStream.listen((position) {
        if (_isDisposed) return;
        currentPosition = position;
        notifyListeners();
      });

      _durationSubscription = audioPlayer.durationStream.listen((duration) {
        if (_isDisposed || duration == null) return;
        audioDuration = duration;
        notifyListeners();
      });

      audioReady = true;
    } catch (e) {
      log('YogaPlayVisualsProvider: audio init failed – $e');
      audioReady = false;
    }
  }

  Future<void> playPause() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        if (audioPlayer.processingState == ProcessingState.completed) {
          await audioPlayer.seek(Duration.zero);
        }
        await audioPlayer.play();
      }
    } catch (e) {
      log('YogaPlayVisualsProvider: playPause error – $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await audioPlayer.seek(position);
    } catch (e) {
      log('YogaPlayVisualsProvider: seek error – $e');
    }
  }

  Future<void> seekForward() async {
    final target = currentPosition + const Duration(seconds: 10);
    await seek(target > totalDuration ? totalDuration : target);
  }

  Future<void> seekBackward() async {
    final target = currentPosition - const Duration(seconds: 10);
    await seek(target < Duration.zero ? Duration.zero : target);
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
