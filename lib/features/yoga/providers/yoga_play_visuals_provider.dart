import 'package:flutter/material.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';

/// Independent provider for managing yoga content display in PlayVisualsCopy
class YogaPlayVisualsProvider with ChangeNotifier {
  final YogaContentModel yogaContent;

  List<YogaSegment> _segments = [];
  Duration _totalDuration = Duration.zero;
  bool _isInitialized = false;

  YogaPlayVisualsProvider({required this.yogaContent}) {
    _initialize();
  }

  List<YogaSegment> get segments => _segments;
  Duration get totalDuration => _totalDuration;
  bool get isInitialized => _isInitialized;

  /// Initialize by parsing yoga content
  void _initialize() {
    try {
      _segments = YogaRichTextParser.parseYogaContent(
        yogaContent.contentDescription,
      );

      // Calculate total duration
      _totalDuration = Duration(
        milliseconds: _segments.fold<int>(
          0,
          (sum, segment) => sum + segment.duration.inMilliseconds,
        ),
      );

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing YogaPlayVisualsProvider: $e');
      _isInitialized = false;
      notifyListeners();
    }
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
}
