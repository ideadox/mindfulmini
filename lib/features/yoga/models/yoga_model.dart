class YogaModel {
  final String id;
  final String title;
  final Map<String, dynamic>? media;
  final List<Map<String, dynamic>>? tags;
  final bool? inSeries;
  final String? seriesName;
  final int? seriesIndex;
  final int? viewCount;

  YogaModel({
    required this.id,
    required this.title,
    this.media,
    this.tags,
    this.inSeries,
    this.seriesName,
    this.seriesIndex,
    this.viewCount,
  });

  factory YogaModel.fromJson(Map<String, dynamic> json) {
    return YogaModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      media: json['media'],
      tags:
          json['tags'] != null
              ? List<Map<String, dynamic>>.from(json['tags'])
              : null,
      inSeries: json['inSeries'],
      seriesName: json['seriesName'],
      seriesIndex: json['seriesIndex'],
      viewCount: json['viewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'media': media,
      'tags': tags,
      'inSeries': inSeries,
      'seriesName': seriesName,
      'seriesIndex': seriesIndex,
      'viewCount': viewCount,
    };
  }
}
