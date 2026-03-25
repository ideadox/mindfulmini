import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/features/library/models/favorite_item.dart';

class RecentViewedItem {
  final String contentId;
  final String collection;
  final String title;
  final String? thumbnailFilename;
  final DateTime viewedAt;
  final int playCount;
  final int completionPercent;

  const RecentViewedItem({
    required this.contentId,
    required this.collection,
    required this.title,
    this.thumbnailFilename,
    required this.viewedAt,
    this.playCount = 1,
    this.completionPercent = 0,
  });

  String? get thumbnailUrl => thumbnailFilename != null
      ? '${ApiConstants.mediaBaseUrl}$thumbnailFilename'
      : null;

  String get collectionLabel =>
      FavoriteItem.collectionDisplayName(collection);

  factory RecentViewedItem.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>?;

    String? thumb;
    if (content != null) {
      final thumbnail = content['thumbnail'];
      final media = content['media'];
      if (thumbnail is Map<String, dynamic>) {
        thumb = thumbnail['filename'] as String?;
      } else if (media is Map<String, dynamic>) {
        thumb = media['filename'] as String?;
      }
    }

    return RecentViewedItem(
      contentId: json['contentId'] ?? '',
      collection: json['collection'] ?? '',
      title: content?['title'] ?? '',
      thumbnailFilename: thumb,
      viewedAt: json['viewedAt'] != null
          ? DateTime.parse(json['viewedAt'])
          : DateTime.now(),
      playCount: json['playCount'] ?? 1,
      completionPercent: json['completionPercent'] ?? 0,
    );
  }
}
