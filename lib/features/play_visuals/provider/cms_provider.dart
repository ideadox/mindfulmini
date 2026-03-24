import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindfulminis/common/data/cms_data.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/injection/injection.dart';

import '../../../common/models/cms_model.dart';
import '../../../common/models/story_segment.dart';

class CmsProvider with ChangeNotifier {
  final _data = sl<CmsData>();
  final AudioPlayer audioPlayer = AudioPlayer();

  late String id;
  late String collection;

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
  bool audioReady = false;
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
    if (cms?.audio?.filename == null) return;

    try {
      final audioUrl = '${ApiConstants.mediaBaseUrl}${cms!.audio!.filename}';
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
        totalDuration = duration;
        notifyListeners();
      });

      audioReady = true;
    } catch (e) {
      log('CmsProvider: audio init failed – $e');
      audioReady = false;
    }
  }

  bool _isDisposed = false;

  Future<void> playPause() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        // On some Android devices play() silently fails after completion.
        if (audioPlayer.processingState == ProcessingState.completed) {
          await audioPlayer.seek(Duration.zero);
        }
        await audioPlayer.play();
      }
    } catch (e) {
      log('CmsProvider: playPause error – $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await audioPlayer.seek(position);
    } catch (e) {
      log('CmsProvider: seek error – $e');
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
