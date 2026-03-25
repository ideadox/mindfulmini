import 'package:mindfulminis/core/api_constants.dart';

class FavoriteItem {
  final String contentId;
  final String collection;
  final String title;
  final String? thumbnailFilename;
  final DateTime favoritedAt;

  const FavoriteItem({
    required this.contentId,
    required this.collection,
    required this.title,
    this.thumbnailFilename,
    required this.favoritedAt,
  });

  String? get thumbnailUrl => thumbnailFilename != null
      ? '${ApiConstants.mediaBaseUrl}$thumbnailFilename'
      : null;

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
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

    return FavoriteItem(
      contentId: json['contentId'] ?? '',
      collection: json['collection'] ?? '',
      title: content?['title'] ?? '',
      thumbnailFilename: thumb,
      favoritedAt: json['favoritedAt'] != null
          ? DateTime.parse(json['favoritedAt'])
          : DateTime.now(),
    );
  }

  static String collectionDisplayName(String collection) {
    switch (collection.toLowerCase()) {
      case 'stories':
        return 'Stories';
      case 'yogas':
      case 'yoga':
        return 'Yoga';
      case 'meditations':
      case 'meditation':
        return 'Meditation';
      case 'breaths':
      case 'breathing':
        return 'Breathing';
      case 'affirmations':
      case 'affirmation':
        return 'Affirmations';
      case 'mindfulness':
        return 'Mindfulness';
      case 'minibodyscans':
        return 'Body Scans';
      default:
        if (collection.isNotEmpty) {
          return collection[0].toUpperCase() + collection.substring(1);
        }
        return collection;
    }
  }
}
