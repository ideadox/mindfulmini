class YogaContentModel {
  final String id;
  final String title;
  final Map<String, dynamic>? contentDescription;
  final Map<String, dynamic>? thumbnail;
  final Map<String, dynamic>? media;
  final Map<String, dynamic>? motionPicture;
  final Map<String, dynamic>? audio;
  final List<Map<String, dynamic>>? tags;
  final bool? inSeries;
  final String? seriesId;
  final int? seriesIndex;
  final int? viewCount;
  final String? createdAt;
  final String? updatedAt;

  String? get cardImageFilename =>
      thumbnail?['filename'] as String? ?? media?['filename'] as String?;

  /// Initial hero: **media** first, then thumbnail (matches [CmsModel.stillVisualMedia]).
  Map<String, dynamic>? get stillVisualMap {
    if (media is Map<String, dynamic>) return media as Map<String, dynamic>;
    if (thumbnail is Map<String, dynamic>) {
      return thumbnail as Map<String, dynamic>;
    }
    return null;
  }

  /// Motion → media → thumbnail.
  Map<String, dynamic>? get playingVisualMap {
    if (motionPicture is Map<String, dynamic>) {
      return motionPicture as Map<String, dynamic>;
    }
    if (media is Map<String, dynamic>) return media as Map<String, dynamic>;
    if (thumbnail is Map<String, dynamic>) {
      return thumbnail as Map<String, dynamic>;
    }
    return null;
  }

  String? get stillImageFilename =>
      stillVisualMap?['filename'] as String?;

  String? get playingImageFilename =>
      playingVisualMap?['filename'] as String?;

  YogaContentModel({
    required this.id,
    required this.title,
    this.contentDescription,
    this.thumbnail,
    this.media,
    this.motionPicture,
    this.audio,
    this.tags,
    this.inSeries,
    this.seriesId,
    this.seriesIndex,
    this.viewCount,
    this.createdAt,
    this.updatedAt,
  });

  factory YogaContentModel.fromJson(Map<String, dynamic> json) {
    return YogaContentModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      contentDescription: json['contentDescription'],
      thumbnail: json['thumbnail'] is Map<String, dynamic> ? json['thumbnail'] : null,
      media: json['media'],
      motionPicture: json['motionPicture'] is Map<String, dynamic> ? json['motionPicture'] : null,
      audio: json['audio'] is Map<String, dynamic> ? json['audio'] : null,
      tags:
          json['tags'] != null
              ? List<Map<String, dynamic>>.from(json['tags'])
              : null,
      inSeries: json['inSeries'],
      seriesId: json['series']?.toString(),
      seriesIndex: json['seriesIndex'],
      viewCount: json['viewCount'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'contentDescription': contentDescription,
      if (thumbnail != null) 'thumbnail': thumbnail,
      'media': media,
      if (motionPicture != null) 'motionPicture': motionPicture,
      'audio': audio,
      'tags': tags,
      'inSeries': inSeries,
      'series': seriesId,
      'seriesIndex': seriesIndex,
      'viewCount': viewCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
