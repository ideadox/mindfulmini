class MeditationModel {
  final String id;
  final String title;
  final Map<String, dynamic>? contentDescription;
  final Map<String, dynamic>? media;
  final List<Map<String, dynamic>>? tags;
  final bool? inSeries;
  final String? seriesId;
  final int? seriesIndex;
  final int? viewCount;
  final String? createdAt;
  final String? updatedAt;

  MeditationModel({
    required this.id,
    required this.title,
    this.contentDescription,
    this.media,
    this.tags,
    this.inSeries,
    this.seriesId,
    this.seriesIndex,
    this.viewCount,
    this.createdAt,
    this.updatedAt,
  });

  factory MeditationModel.fromJson(Map<String, dynamic> json) {
    return MeditationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      contentDescription: json['contentDescription'],
      media: json['media'],
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
      'media': media,
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
