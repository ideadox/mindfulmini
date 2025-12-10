class StorySegment {
  final String text;
  final Duration delay;

  StorySegment({
    required this.text,
    this.delay = const Duration(milliseconds: 0),
  });
}
