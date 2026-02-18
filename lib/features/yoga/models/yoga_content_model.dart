class YogaContentModel {
  final String id;
  final String title;
  final Map<String, dynamic>? contentDescription;
  final Map<String, dynamic>? media;
  final Map<String, dynamic>? audio;
  final List<Map<String, dynamic>>? tags;
  final bool? inSeries;
  final String? seriesName;
  final int? seriesIndex;
  final int? viewCount;
  final String? createdAt;
  final String? updatedAt;

  YogaContentModel({
    required this.id,
    required this.title,
    this.contentDescription,
    this.media,
    this.audio,
    this.tags,
    this.inSeries,
    this.seriesName,
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
      media: json['media'],
      audio: json['audio'] is Map<String, dynamic> ? json['audio'] : null,
      tags:
          json['tags'] != null
              ? List<Map<String, dynamic>>.from(json['tags'])
              : null,
      inSeries: json['inSeries'],
      seriesName: json['seriesName'],
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
      'media': media,
      'audio': audio,
      'tags': tags,
      'inSeries': inSeries,
      'seriesName': seriesName,
      'seriesIndex': seriesIndex,
      'viewCount': viewCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
