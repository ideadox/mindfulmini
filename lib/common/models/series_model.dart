import 'package:mindfulminis/common/models/cms_model.dart';

class SeriesModel {
  final String slug;
  final String displayName;
  final String? description;
  final Media? thumbnail;
  final int itemCount;
  final List<CmsModel> items;

  SeriesModel({
    required this.slug,
    required this.displayName,
    this.description,
    this.thumbnail,
    required this.itemCount,
    required this.items,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    return SeriesModel(
      slug: json['seriesSlug'] ?? '',
      displayName: json['seriesDisplayName'] ?? '',
      description: json['seriesDescription'],
      thumbnail: json['seriesThumbnail'] != null
          ? Media.fromJson(json['seriesThumbnail'])
          : null,
      itemCount: json['itemCount'] ?? 0,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => CmsModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
