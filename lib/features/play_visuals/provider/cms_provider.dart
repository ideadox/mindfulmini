import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:mindfulminis/common/data/cms_data.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/utils/yoga_rich_text_parser.dart';
import 'package:mindfulminis/features/yoga/models/yoga_content_model.dart';

import '../../../common/models/audio_timings.dart';
import '../../../common/models/cms_model.dart';
import '../../../common/models/story_segment.dart';

/// Unified provider for all play-visuals content (stories, meditation,
/// breathing, yoga, etc.). Handles CMS fetch + audio lifecycle.
class CmsProvider with ChangeNotifier {
  final _data = sl<CmsData>();
  final AudioPlayer audioPlayer = AudioPlayer();

  late final String id;
  late final String collection;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;

  // ── Content ──

  CmsModel? cms;
  List<StorySegment> segments = [];
  List<YogaSegment> yogaSegments = [];

  /// Character-level ElevenLabs alignment for the current audio, when
  /// available. Drives exact text/audio sync in the lyric view. `null` for
  /// legacy content generated before the timestamps rollout.
  AudioTimings? audioTimings;

  bool isLoading = true;
  bool isPlaying = false;
  bool audioReady = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  /// True when this provider was created for yoga content.
  final bool isYoga;

  // ── Constructors ──

  /// CMS-based content (stories, meditation, breathing, …).
  CmsProvider(this.collection, this.id) : isYoga = false {
    _fetchCmsContent();
  }

  /// Yoga content – data is already available, only needs parsing + audio.
  CmsProvider.yoga(YogaContentModel yogaContent)
      : id = yogaContent.id,
        collection = 'yoga',
        isYoga = true {
    _initFromYoga(yogaContent);
  }

  // ── Initialisation ──

  Future<void> _fetchCmsContent() async {
    try {
      isLoading = true;
      cms = await _data.getCMSById(collection, id);
      if (cms != null) {
        segments = parseLexicalJson(cms!.contentDescriptionJson);
      }
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'CmsProvider fetch failed for $collection/$id');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    // Audio init in background – UI is already visible
    _initializeAudio(cms?.audio?.filename);
    _loadTimings(cms?.audioTimings?.filename);
  }

  Future<void> _initFromYoga(YogaContentModel yogaContent) async {
    try {
      isLoading = true;
      yogaSegments = YogaRichTextParser.parseYogaContent(
        yogaContent.contentDescription,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'CmsProvider yoga init failed for ${yogaContent.id}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    // Audio init in background – UI is already visible
    final audioFilename = yogaContent.audio?['filename'] as String?;
    _initializeAudio(audioFilename);
  }

  // ── Audio ──

  Future<void> _loadTimings(String? filename) async {
    if (filename == null || filename.isEmpty) return;
    final url = '${ApiConstants.mediaBaseUrl}$filename';
    try {
      final resp = await http.get(Uri.parse(url));
      if (_isDisposed) return;
      if (resp.statusCode != 200) {
        // Non-fatal: the lyric view falls back to proportional sync.
        return;
      }
      audioTimings = AudioTimings.fromJsonString(resp.body);
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'CmsProvider timings load failed for url=$url',
      );
    }
  }

  Future<void> _initializeAudio(String? filename) async {
    if (filename == null) return;

    try {
      final audioUrl = '${ApiConstants.mediaBaseUrl}$filename';
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
      notifyListeners();
    } on MissingPluginException {
      // setPitch not implemented on some platforms – safe to ignore since
      // audio playback still works without pitch control.
      audioReady = true;
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'CmsProvider audio init failed for id=$id collection=$collection',
      );
      audioReady = false;
    }
  }

  bool _isDisposed = false;

  // ── Playback controls ──

  Future<void> playPause() async {
    if (!audioReady) return;
    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        if (audioPlayer.processingState == ProcessingState.completed) {
          await audioPlayer.seek(Duration.zero);
        }
        await audioPlayer.play();
      }
    } on MissingPluginException {
      // Ignore – setPitch / platform gaps on some Android devices.
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'CmsProvider playPause failed');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await audioPlayer.seek(position);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack,
          reason: 'CmsProvider seek failed');
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

  // ── Lifecycle ──

  @override
  void dispose() {
    _isDisposed = true;
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  // ── Segment parsing (CMS) ──

  List<StorySegment> parseLexicalJson(Map<String, dynamic> json) {
    final List<StorySegment> segments = [];

    void walk(node) {
      if (node is Map) {
        if (node['type'] == 'text') {
          String raw = node['text'] ?? "";

          String cleaned =
              raw
                  .replaceAll(RegExp(r'<break time="([\d.]+)s"\s*\/>'), "")
                  .trim();

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
