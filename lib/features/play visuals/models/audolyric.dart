// Define one chapter
class AudioChapter {
  final String title;
  final Duration start;
  final Duration end;

  AudioChapter({required this.title, required this.start, required this.end});
}

// Define one lyric line
class LyricLine {
  final Duration timestamp;
  final String text;

  LyricLine({required this.timestamp, required this.text});
}
