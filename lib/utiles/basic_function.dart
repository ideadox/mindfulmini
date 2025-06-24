import '../gen/assets.gen.dart';

class BasicFunction {
  static int countWords(String sentence) {
    if (sentence.trim().isEmpty) return 0;

    return sentence
        .trim()
        .split(
          RegExp(r'\s+'),
        ) // Split by any whitespace (space, tabs, newlines)
        .length;
  }

  static getJounalEmoji(String emotion) {
    switch (emotion) {
      case 'Amazing':
        return Assets.icons.amazingEmoji;
      case 'Happy':
        return Assets.icons.happy;

      case 'Confused':
        return Assets.icons.confushedEmoji;

      case 'Sad':
        return Assets.icons.sadEmoji;

      case 'Upset':
        return Assets.icons.upsetEmoji;

      default:
        return '';
    }
  }
}
