class YogaModel {
  final String id;
  final String title;
  final Map<String, dynamic>? thumbnail;
  final Map<String, dynamic>? media;
  final List<Map<String, dynamic>>? tags;
  final bool? inSeries;
  final String? seriesId;
  final int? seriesIndex;
  final int? viewCount;

  String? get cardImageFilename =>
      thumbnail?['filename'] as String? ?? media?['filename'] as String?;

  YogaModel({
    required this.id,
    required this.title,
    this.thumbnail,
    this.media,
    this.tags,
    this.inSeries,
    this.seriesId,
    this.seriesIndex,
    this.viewCount,
  });

  factory YogaModel.fromJson(Map<String, dynamic> json) {
    return YogaModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] is Map<String, dynamic> ? json['thumbnail'] : null,
      media: json['media'],
      tags:
          json['tags'] != null
              ? List<Map<String, dynamic>>.from(json['tags'])
              : null,
      inSeries: json['inSeries'],
      seriesId: json['series']?.toString(),
      seriesIndex: json['seriesIndex'],
      viewCount: json['viewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      if (thumbnail != null) 'thumbnail': thumbnail,
      'media': media,
      'tags': tags,
      'inSeries': inSeries,
      'series': seriesId,
      'seriesIndex': seriesIndex,
      'viewCount': viewCount,
    };
  }
}
