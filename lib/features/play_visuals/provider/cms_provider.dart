import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindfulminis/common/data/cms_data.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/models/cms_model.dart';
import '../../../common/models/story_segment.dart';

class CmsProvider with ChangeNotifier {
  final _data = sl<CmsData>();
  final AudioPlayer audioPlayer = AudioPlayer();

  late String id;
  late String collection;

  // Stream subscriptions for proper disposal
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  CmsProvider(this.collection, this.id) {
    getCMSContentByCollection();
  }

  CmsModel? cms;
  List<StorySegment> segments = [];
  bool isLoading = false;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  Future<void> getCMSContentByCollection() async {
    try {
      isLoading = true;
      cms = await _data.getCMSById(collection, id);
      if (cms != null) {
        segments = parseLexicalJson(cms!.contentDescriptionJson);
        await _initializeAudio();
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initializeAudio() async {
    if (cms?.audio?.filename != null) {
      try {
        final audioUrl = '${ApiConstants.mediaBaseUrl}${cms!.audio!.filename}';
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
            totalDuration = duration;
            notifyListeners();
          }
        });
      } catch (e) {
        print('Error initializing audio: $e');
      }
    }
  }

  bool _isDisposed = false;

  Future<void> playPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  Future<void> seekForward() async {
    final newPosition = currentPosition + Duration(seconds: 10);
    await seek(newPosition > totalDuration ? totalDuration : newPosition);
  }

  Future<void> seekBackward() async {
    final newPosition = currentPosition - Duration(seconds: 10);
    await seek(newPosition < Duration.zero ? Duration.zero : newPosition);
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

  List<StorySegment> parseLexicalJson(Map<String, dynamic> json) {
    final List<StorySegment> segments = [];

    void walk(node) {
      if (node is Map) {
        if (node['type'] == 'text') {
          String raw = node['text'] ?? "";

          // --- REMOVE break tags from text ---
          String cleaned =
              raw
                  .replaceAll(RegExp(r'<break time="([\d.]+)s"\s*\/>'), "")
                  .trim();

          // Extract breaks separately
          final breakRegex = RegExp(r'<break time="([\d.]+)s"\s*\/>');
          final breaks = breakRegex.allMatches(raw);

          if (cleaned.isNotEmpty) {
            segments.add(StorySegment(text: cleaned));
          }

          for (final match in breaks) {
            final seconds = double.parse(match.group(1)!);
            segments.add(
              StorySegment(
                text: "",
                delay: Duration(milliseconds: (seconds * 1000).toInt()),
              ),
            );
          }
        }

        if (node['children'] != null) {
          for (var child in node['children']) {
            walk(child);
          }
        }
      }
    }

    walk(json['root']);
    return segments;
  }
}
