import 'dart:developer';

import 'package:flutter/material.dart';

/// Represents a formatted text span within a yoga segment
class YogaTextSpan {
  final String text;
  final bool isBold;
  final bool isItalic;

  YogaTextSpan({
    required this.text,
    this.isBold = false,
    this.isItalic = false,
  });

  TextStyle get textStyle {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      fontSize: 16,
      color: Colors.black87,
      height: 1.6,
    );
  }
}


class YogaSegment {
  final List<YogaTextSpan> textSpans;
  final Duration duration;

  YogaSegment({required this.textSpans, required this.duration});

  /// Get the full text content of this segment
  String get fullText => textSpans.map((span) => span.text).join();

  /// Get the character count for timing calculations
  int get charCount => fullText.length;
}

class YogaRichTextParser {
  static List<YogaSegment> parseYogaContent(
    Map<String, dynamic>? contentDescription,
  ) {
    if (contentDescription == null || contentDescription.isEmpty) {
      return [];
    }

    try {
      final root = contentDescription['root'] as Map<String, dynamic>?;
      if (root == null) return [];

      final children = root['children'] as List<dynamic>? ?? [];
      final segments = <YogaSegment>[];

      for (final child in children) {
        if (child is! Map<String, dynamic>) continue;

        final type = child['type'] as String?;
        if (type == 'paragraph') {
          // Parse each line in the paragraph as a separate segment
          final lines = _parseParagraphLines(child);
          segments.addAll(lines);
        }
      }

      return segments;
    } catch (e) {
      log('Error parsing yoga content: $e');
      return [];
    }
  }
 

  static List<YogaSegment> _parseParagraphLines(
    Map<String, dynamic> paragraph,
  ) {
    final children = paragraph['children'] as List<dynamic>? ?? [];
    final lineSegments = <YogaSegment>[];
    var currentLineSpans = <YogaTextSpan>[];

    for (final child in children) {
      if (child is! Map<String, dynamic>) continue;

      final childType = child['type'] as String?;

      if (childType == 'text') {
        final text = child['text'] as String? ?? '';
        if (text.isNotEmpty && text.trim().isNotEmpty) {
          final format = child['format'] as int? ?? 0;
          final isBold = (format & 1) != 0;
          final isItalic = (format & 2) != 0;

          currentLineSpans.add(
            YogaTextSpan(text: text, isBold: isBold, isItalic: isItalic),
          );
        }
      } else if (childType == 'linebreak') {
        // End current line and start new one
        if (currentLineSpans.isNotEmpty) {
          final segment = _createSegment(currentLineSpans);
          if (segment != null) {
            lineSegments.add(segment);
          }
          currentLineSpans = [];
        }
      }
    }

    if (currentLineSpans.isNotEmpty) {
      final segment = _createSegment(currentLineSpans);
      if (segment != null) {
        lineSegments.add(segment);
      }
    }

    return lineSegments;
  }

  static YogaSegment? _createSegment(List<YogaTextSpan> textSpans) {
    if (textSpans.isEmpty) return null;

    // Calculate duration based on character count
    final charCount = textSpans.fold<int>(
      0,
      (sum, span) => sum + span.text.length,
    );
    final durationMs = (800 + (charCount * 40)).clamp(1200, 15000);
    final duration = Duration(milliseconds: durationMs);

    return YogaSegment(textSpans: textSpans, duration: duration);
  }

  static YogaSegment? _parseParagraph(Map<String, dynamic> paragraph) {
    final children = paragraph['children'] as List<dynamic>? ?? [];
    final textSpans = <YogaTextSpan>[];

    for (final child in children) {
      if (child is! Map<String, dynamic>) continue;

      final childType = child['type'] as String?;

      if (childType == 'text') {
        final text = child['text'] as String? ?? '';
        if (text.isNotEmpty && text.trim().isNotEmpty) {
          final format = child['format'] as int? ?? 0;
          final isBold = (format & 1) != 0; // format == 1 = bold
          final isItalic = (format & 2) != 0; // format == 2 = italic

          textSpans.add(
            YogaTextSpan(text: text, isBold: isBold, isItalic: isItalic),
          );
        }
      } else if (childType == 'linebreak') {
        // Add newline as text span
        textSpans.add(YogaTextSpan(text: '\n'));
      }
    }

    if (textSpans.isEmpty) return null;

    // Calculate duration based on character count
    // Formula: base 800ms + 40ms per character, minimum 1200ms
    final charCount = textSpans.fold<int>(
      0,
      (sum, span) => sum + span.text.replaceAll('\n', '').length,
    );
    final durationMs = (800 + (charCount * 40)).clamp(1200, 15000);
    final duration = Duration(milliseconds: durationMs);

    return YogaSegment(textSpans: textSpans, duration: duration);
  }
}


class YogaSegmentWidget extends StatelessWidget {
  final YogaSegment segment;
  final Animation<double> animation;

  const YogaSegmentWidget({
    super.key,
    required this.segment,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Text.rich(
        TextSpan(
          children:
              segment.textSpans
                  .map(
                    (span) => TextSpan(text: span.text, style: span.textStyle),
                  )
                  .toList(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
