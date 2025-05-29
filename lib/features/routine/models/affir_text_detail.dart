class AffirTextDetail {
  final double start;
  final double end;
  final String text;
  final bool isGradientText;

  AffirTextDetail({
    required this.start,
    required this.end,
    required this.text,
    this.isGradientText = false,
  });
}
