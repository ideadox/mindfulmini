import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/common/models/series_model.dart';

class DiscoverSection {
  final String type;
  final SeriesModel? series;
  final CmsModel? item;

  DiscoverSection({
    required this.type,
    this.series,
    this.item,
  });

  bool get isSeries => type == 'series';
  bool get isSingle => type == 'single';

  factory DiscoverSection.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'single';
    return DiscoverSection(
      type: type,
      series: type == 'series' ? SeriesModel.fromJson(json) : null,
      item: type == 'single' && json['item'] != null
          ? CmsModel.fromJson(json['item'] as Map<String, dynamic>)
          : null,
    );
  }
}
