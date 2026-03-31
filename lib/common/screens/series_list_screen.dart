import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/common/models/series_model.dart';
import 'package:mindfulminis/common/providers/collection_discover_provider.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/features/yoga/data/yoga_data.dart';
import 'package:provider/provider.dart';

class SeriesListScreen extends StatelessWidget {
  static String routeName = 'series-list';
  static String routePath = '/series-list';

  final SeriesModel series;
  final String collectionSlug;
  final CollectionDiscoverProvider discoverProvider;

  const SeriesListScreen({
    super.key,
    required this.series,
    required this.collectionSlug,
    required this.discoverProvider,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = series.thumbnail != null
        ? ApiConstants.mediaBaseUrl + series.thumbnail!.filename
        : (series.items.isNotEmpty && series.items.first.cardImageFilename != null
            ? ApiConstants.mediaBaseUrl + series.items.first.cardImageFilename!
            : null);

    return ChangeNotifierProvider.value(
      value: discoverProvider,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(
                    height: 260,
                    width: double.infinity,
                    child: thumbnailUrl != null
                        ? CachedNetworkImage(
                            imageUrl: thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: Colors.grey.shade200),
                            errorWidget: (_, __, ___) =>
                                Container(color: Colors.grey.shade200),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                            ),
                          ),
                  ),
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 50,
                    child: CustomBackButton(hasBackground: true),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          series.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (series.description != null &&
                            series.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            series.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 14,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          _headerSubtitle(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'All Items',
                  style: AppTextTheme.titleTextTheme(context)
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              sliver: Consumer<CollectionDiscoverProvider>(
                builder: (context, provider, _) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = series.items[index];
                        return _buildSeriesItem(
                          context,
                          item,
                          index,
                          provider,
                        );
                      },
                      childCount: series.items.length,
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight + 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSeriesItem(
    BuildContext context,
    CmsModel item,
    int index,
    CollectionDiscoverProvider provider,
  ) {
    final isViewed = provider.isViewed(item.id);
    final thumbnailUrl = item.cardImageFilename != null
        ? ApiConstants.mediaBaseUrl + item.cardImageFilename!
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToPlayVisuals(item),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: thumbnailUrl != null
                      ? CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: Colors.grey.shade200),
                          errorWidget: (_, __, ___) =>
                              Container(color: Colors.grey.shade200),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.secondaryGradient,
                          ),
                        ),
                ),
              ),
              Space.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _episodeMetadata(item),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: isViewed
                    ? Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child:
                            Icon(Icons.check, color: Colors.white, size: 16),
                      )
                    : Icon(
                        Icons.play_circle_outline,
                        color: AppColors.primary,
                        size: 26,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _headerSubtitle() {
    final totalMinutes = series.items.fold<int>(
      0,
      (sum, item) => sum + item.estimatedDuration.inMinutes,
    );
    final itemsLabel = '${series.itemCount} items';
    if (totalMinutes <= 0) return itemsLabel;
    return '$itemsLabel · ${AppFormate.formatReadDuration(Duration(minutes: totalMinutes))}';
  }

  String _episodeMetadata(CmsModel item) {
    final parts = <String>[];
    if (item.viewCount > 0) parts.add('${item.viewCount} views');
    if (item.estimatedDuration.inMinutes > 0) {
      parts.add(AppFormate.formatReadDuration(item.estimatedDuration));
    }
    return parts.isEmpty ? '' : parts.join(' · ');
  }

  void _navigateToPlayVisuals(CmsModel item) async {
    if (collectionSlug == 'yoga') {
      try {
        final yogaData = sl<YogaData>();
        final yogaContent = await yogaData.getYogaContentById(item.id);
        sl<GoRouter>().pushNamed(
          PlayVisuals.routeName,
          extra: yogaContent,
        );
      } catch (e) {
        log('Error fetching yoga content: $e');
      }
    } else {
      sl<GoRouter>().pushNamed(
        PlayVisuals.routeName,
        queryParameters: {
          'collection': collectionSlug,
          'id': item.id,
        },
      );
    }
  }
}
