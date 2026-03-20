import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/core/api_constants.dart';

/// Resolved media for the play screen: filename, mime, and absolute URL.
class PlayVisualAsset {
  final String filename;
  final String mimeType;
  final String url;

  const PlayVisualAsset({
    required this.filename,
    required this.mimeType,
    required this.url,
  });

  bool get isVideo => mimeType.startsWith('video/');

  bool get isRasterImage =>
      mimeType.startsWith('image/') && mimeType != 'image/svg+xml';

  static PlayVisualAsset? fromMedia(Media? m) {
    if (m == null || m.filename.isEmpty) return null;
    return PlayVisualAsset(
      filename: m.filename,
      mimeType: m.mimeType,
      url: '${ApiConstants.mediaBaseUrl}${m.filename}',
    );
  }

  /// Initial hero: [media] first, then [thumbnail].
  static PlayVisualAsset? stillFromCms(CmsModel? cms) {
    if (cms == null) return null;
    return fromMedia(cms.stillVisualMedia);
  }

  /// While playing: motion → media → thumbnail.
  static PlayVisualAsset? playingFromCms(CmsModel? cms) {
    if (cms == null) return null;
    return fromMedia(cms.playingVisualMedia);
  }

  static PlayVisualAsset? tryParseMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    final fn = map['filename'] as String?;
    if (fn == null || fn.isEmpty) return null;
    final rawMime = map['mimeType'] as String?;
    final mime = (rawMime != null && rawMime.isNotEmpty)
        ? rawMime
        : guessMimeFromFilename(fn);
    return PlayVisualAsset(
      filename: fn,
      mimeType: mime,
      url: '${ApiConstants.mediaBaseUrl}$fn',
    );
  }

  static String guessMimeFromFilename(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.mp4')) return 'video/mp4';
    if (lower.endsWith('.webm')) return 'video/webm';
    if (lower.endsWith('.ogg') || lower.endsWith('.ogv')) return 'video/ogg';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    return 'application/octet-stream';
  }
}
