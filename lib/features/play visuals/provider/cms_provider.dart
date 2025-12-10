import 'package:flutter/material.dart';
import 'package:mindfulminis/common/data/cms_data.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../common/models/cms_model.dart';
import '../../../common/models/story_segment.dart';

class CmsProvider with ChangeNotifier {
  final _data = sl<CmsData>();

  late String id;
  late String collection;

  CmsProvider(this.collection, this.id) {
    getCMSContentByCollection();
  }

  CmsModel? cms;
  List<StorySegment> segments = [];
  bool isLoading = false;
  Future<void> getCMSContentByCollection() async {
    try {
      isLoading = true;
      cms = await _data.getCMSById(collection, id);
      if (cms != null) {
        segments = parseLexicalJson(cms!.contentDescriptionJson);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
