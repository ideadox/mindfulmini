import '../../gen/assets.gen.dart';

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
 
  static String getJounalEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'amazing':
        return Assets.icons.amazingEmoji;
      case 'happy':
        return Assets.icons.happy;
      case 'confused':
        return Assets.icons.confushedEmoji;
      case 'sad':
        return Assets.icons.sadEmoji;
      case 'upset':
        return Assets.icons.upsetEmoji;
      default:
        return Assets.icons.happy;
    }
  }
}
