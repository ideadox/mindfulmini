import 'dart:convert';

/// Character-level audio timings returned by ElevenLabs'
/// `text_to_speech.convert_with_timestamps` endpoint.
///
/// The TTS service persists the raw JSON as a sibling file to the MP3 and
/// PayloadCMS attaches it as an `audioTimings` media doc. The Flutter app
/// loads it over HTTP and uses [endMsForSubstring] to find the precise audio
/// time at which any visible text chunk finishes being spoken — so the lyric
/// view can advance lines in lock-step with the narrator instead of relying
/// on proportional weights.
class AudioTimings {
  /// The joined text as ElevenLabs processed it, minus `<break .../>` tags.
  /// Indices into this string correspond 1:1 with [_visibleStartMs] and
  /// [_visibleEndMs].
  final String visibleText;

  /// Start time in milliseconds for each character in [visibleText].
  final List<int> _visibleStartMs;

  /// End time in milliseconds for each character in [visibleText].
  final List<int> _visibleEndMs;

  /// Total spoken duration in milliseconds (end of the last input character,
  /// including any trailing break).
  final int totalMs;

  AudioTimings._({
    required this.visibleText,
    required List<int> visibleStartMs,
    required List<int> visibleEndMs,
    required this.totalMs,
  })  : _visibleStartMs = visibleStartMs,
        _visibleEndMs = visibleEndMs;

  /// Matches `<break time="Xs" />` (and a couple of common variations).
  /// Anything between the opening `<` of `<break` and the matching `>` is
  /// stripped from the visible text, and the corresponding alignment entries
  /// are dropped. Any sustained silence from the break still shows up as a
  /// gap between the end time of the character before `<` and the start of
  /// the character after `>`.
  static final _breakOpen = '<break';

  factory AudioTimings.fromJsonString(String raw) {
    final parsed = json.decode(raw);
    if (parsed is! Map) {
      throw FormatException('audioTimings JSON must be an object');
    }
    return AudioTimings.fromJson(parsed.cast<String, dynamic>());
  }

  factory AudioTimings.fromJson(Map<String, dynamic> data) {
    final chars = (data['characters'] as List?)?.cast<String>() ?? const <String>[];
    final startSec =
        (data['character_start_times_seconds'] as List?)?.cast<num>() ?? const <num>[];
    final endSec =
        (data['character_end_times_seconds'] as List?)?.cast<num>() ?? const <num>[];

    if (chars.length != endSec.length || chars.length != startSec.length) {
      throw FormatException(
        'audioTimings arrays misaligned: ${chars.length} chars, '
        '${startSec.length} starts, ${endSec.length} ends',
      );
    }

    final visible = StringBuffer();
    final visibleStartMs = <int>[];
    final visibleEndMs = <int>[];

    int i = 0;
    while (i < chars.length) {
      // Detect the start of a `<break...>` tag and skip up to and including `>`.
      if (chars[i] == '<' && _startsWithBreak(chars, i)) {
        while (i < chars.length && chars[i] != '>') {
          i++;
        }
        if (i < chars.length) i++; // consume the '>'
        continue;
      }
      visible.write(chars[i]);
      visibleStartMs.add((startSec[i].toDouble() * 1000).round());
      visibleEndMs.add((endSec[i].toDouble() * 1000).round());
      i++;
    }

    final totalMs = endSec.isEmpty ? 0 : (endSec.last.toDouble() * 1000).round();

    return AudioTimings._(
      visibleText: visible.toString(),
      visibleStartMs: visibleStartMs,
      visibleEndMs: visibleEndMs,
      totalMs: totalMs,
    );
  }

  static bool _startsWithBreak(List<String> chars, int i) {
    if (i + _breakOpen.length > chars.length) return false;
    for (int k = 0; k < _breakOpen.length; k++) {
      if (chars[i + k] != _breakOpen[k]) return false;
    }
    return true;
  }

  /// Start time (ms) of the first character of [substring], searching
  /// forward from [fromIndex] in [visibleText]. Returns `null` if not found.
  /// Writes the position *after* the match into [cursorOut] so callers can
  /// thread a cursor through successive lookups without a wrapper object.
  ///
  /// Activation uses the *start* time rather than the end time so that a
  /// line stays visible across any trailing silence (e.g. authored
  /// `<break>` pauses) until the next line is actually spoken.
  ///
  /// Matching is whitespace-tolerant: runs of whitespace in either the
  /// needle or the haystack collapse to a single space before comparison,
  /// which keeps alignment robust against the padding spaces inserted when
  /// joining Lexical text nodes on the server side.
  int? startMsForSubstring(
    String substring, {
    required int fromIndex,
    List<int>? cursorOut,
  }) {
    final res = _findSubstring(substring, fromIndex: fromIndex);
    if (res == null) return null;
    if (cursorOut != null && cursorOut.isNotEmpty) cursorOut[0] = res.endExclusive;
    if (res.firstIndex < 0) return 0;
    if (res.firstIndex >= _visibleStartMs.length) return totalMs;
    return _visibleStartMs[res.firstIndex];
  }

  /// End time (ms) of the last character of [substring]. Kept for callers
  /// that still prefer end-based timing (not used by the lyric view).
  int? endMsForSubstring(
    String substring, {
    required int fromIndex,
    List<int>? cursorOut,
  }) {
    final res = _findSubstring(substring, fromIndex: fromIndex);
    if (res == null) return null;
    if (cursorOut != null && cursorOut.isNotEmpty) cursorOut[0] = res.endExclusive;
    final endIdx = res.endExclusive - 1;
    if (endIdx < 0) return 0;
    if (endIdx >= _visibleEndMs.length) return totalMs;
    return _visibleEndMs[endIdx];
  }

  _SubstringMatch? _findSubstring(String substring, {required int fromIndex}) {
    if (substring.isEmpty) return null;
    final needle = _collapseWhitespace(substring);
    if (needle.isEmpty) return null;

    final haystack = visibleText;
    final start = fromIndex.clamp(0, haystack.length);

    int h = start;
    while (h < haystack.length) {
      final match = _matchAt(haystack, h, needle);
      if (match != null) return _SubstringMatch(firstIndex: h, endExclusive: match);
      h++;
    }
    return null;
  }

  /// Attempts to match [needle] (already whitespace-collapsed) against
  /// [haystack] starting at [start]. Returns the haystack index just after
  /// the match on success, or `null` on failure.
  static int? _matchAt(String haystack, int start, String needle) {
    int h = start;
    int n = 0;
    while (n < needle.length) {
      if (h >= haystack.length) return null;
      final nc = needle.codeUnitAt(n);
      final hc = haystack.codeUnitAt(h);
      if (nc == 0x20) {
        // Skip any run of whitespace in the haystack.
        if (!_isWhitespace(hc)) return null;
        h++;
        while (h < haystack.length && _isWhitespace(haystack.codeUnitAt(h))) {
          h++;
        }
        n++;
      } else if (_isWhitespace(hc)) {
        // Haystack has whitespace where needle doesn't — allow it only if
        // both sides collapsed to nothing; otherwise fail.
        return null;
      } else {
        if (nc != hc) return null;
        h++;
        n++;
      }
    }
    return h;
  }

  static bool _isWhitespace(int codeUnit) =>
      codeUnit == 0x20 || codeUnit == 0x09 || codeUnit == 0x0A || codeUnit == 0x0D;

  static String _collapseWhitespace(String input) {
    final buf = StringBuffer();
    bool inSpace = false;
    for (int i = 0; i < input.length; i++) {
      final c = input.codeUnitAt(i);
      if (_isWhitespace(c)) {
        if (!inSpace && buf.isNotEmpty) buf.writeCharCode(0x20);
        inSpace = true;
      } else {
        buf.writeCharCode(c);
        inSpace = false;
      }
    }
    final out = buf.toString();
    return out.endsWith(' ') ? out.substring(0, out.length - 1) : out;
  }
}

class _SubstringMatch {
  final int firstIndex;
  final int endExclusive;
  const _SubstringMatch({required this.firstIndex, required this.endExclusive});
}
