import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/data/discover_data.dart';
import 'package:mindfulminis/common/models/cms_model.dart';
import 'package:mindfulminis/common/models/series_model.dart';
import 'package:mindfulminis/common/providers/collection_discover_provider.dart';
import 'package:mindfulminis/common/widgets/collection_card_duration_badge.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/views_widget.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/features/yoga/data/yoga_data.dart';
import 'package:provider/provider.dart';

class CollectionDiscoverScreen extends StatefulWidget {
  final String collectionSlug;
  final String title;
  final String subtitle;
  final String headerImage;

  const CollectionDiscoverScreen({
    super.key,
    required this.collectionSlug,
    required this.title,
    required this.subtitle,
    required this.headerImage,
  });

  @override
  State<CollectionDiscoverScreen> createState() =>
      _CollectionDiscoverScreenState();
}

class _CollectionDiscoverScreenState extends State<CollectionDiscoverScreen> {
  CollectionDiscoverProvider? _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      final profileId = profileProvider.userProfile?.id;

      final provider = CollectionDiscoverProvider(
        discoverData: sl<DiscoverData>(),
        collectionSlug: widget.collectionSlug,
        profileId: profileId,
      );
      provider.fetchDiscoverContent();
      setState(() => _provider = provider);
    });
  }

  @override
  void dispose() {
    _provider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = _provider;
    if (provider == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        body: Consumer<CollectionDiscoverProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return _buildShimmer();
            }
            return _buildContent(context, provider);
          },
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Center(child: CircularProgressIndicator());
  }

  List<Widget> _buildSectionSlivers(CollectionDiscoverProvider provider) {
    final slivers = <Widget>[];
    final sections = provider.sections;
    List<CmsModel> singleBatch = [];

    void flushSingles() {
      if (singleBatch.isEmpty) return;
      final items = List<CmsModel>.from(singleBatch);
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 177 / 268,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildSingleCard(context, items[index], provider),
              childCount: items.length,
            ),
          ),
        ),
      );
      singleBatch = [];
    }

    for (final section in sections) {
      if (section.isSeries && section.series != null) {
        flushSingles();
        slivers.add(
          SliverToBoxAdapter(
            child: _buildSeriesSection(context, section.series!, provider),
          ),
        );
      } else if (section.isSingle && section.item != null) {
        singleBatch.add(section.item!);
      }
    }
    flushSingles();

    return slivers;
  }

  Widget _buildContent(
    BuildContext context,
    CollectionDiscoverProvider provider,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(widget.headerImage),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 50,
                child: CustomBackButton(hasBackground: true),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.titleTextTheme(context).titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 22),
                ),
                Space.h4,
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bodyTextStyle(
                    context,
                  ).bodyMedium?.copyWith(fontSize: 14),
                ),
                Space.h16,
              ],
            ),
          ),
        ),
        if (provider.sections.isEmpty && !provider.isLoading)
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No content available yet',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ),
        ..._buildSectionSlivers(provider),
        SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight + 40)),
      ],
    );
  }

  Widget _buildSeriesSection(
    BuildContext context,
    SeriesModel series,
    CollectionDiscoverProvider provider,
  ) {
    final allItemIds = series.items.map((e) => e.id).toList();
    final isFullyViewed = provider.isSeriesFullyViewed(allItemIds);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        series.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _seriesSubtitle(series),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isFullyViewed) _buildViewedBadge(),
              ],
            ),
          ),
          Space.h12,
          SizedBox(
            height: 268,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: series.items.length,
              separatorBuilder: (_, __) => Space.w12,
              itemBuilder: (context, index) {
                final item = series.items[index];
                return SizedBox(
                  width: 177,
                  child: _buildSingleCard(context, item, provider),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleCard(
    BuildContext context,
    CmsModel item,
    CollectionDiscoverProvider provider,
  ) {
    final isViewed = provider.isViewed(item.id);
    final thumbnailUrl =
        item.cardImageFilename != null
            ? Uri.encodeFull(
              ApiConstants.mediaBaseUrl + item.cardImageFilename!,
            )
            : null;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _navigateToPlayVisuals(context, item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (thumbnailUrl != null)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder:
                      (_, __) => Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                  errorWidget:
                      (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey.shade400,
                        ),
                      ),
                ),
              )
            else
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.secondaryGradient,
                  ),
                ),
              ),
            Positioned(
              right: 8,
              top: 8,
              child: ViewsWidget(totalViews: item.viewCount),
            ),
            if (isViewed)
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
            if (item.estimatedDuration.inMinutes > 0)
              Positioned(
                right: 8,
                bottom: 8,
                child: CollectionCardDurationBadge(
                  label: AppFormate.formatReadDuration(item.estimatedDuration),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToPlayVisuals(BuildContext context, CmsModel item) async {
    if (widget.collectionSlug == 'yoga') {
      try {
        final yogaData = sl<YogaData>();
        final yogaContent = await yogaData.getYogaContentById(item.id);
        sl<GoRouter>().pushNamed(PlayVisuals.routeName, extra: yogaContent);
      } catch (e) {
        log('Error fetching yoga content: $e');
      }
    } else {
      sl<GoRouter>().pushNamed(
        PlayVisuals.routeName,
        queryParameters: {'collection': widget.collectionSlug, 'id': item.id},
      );
    }
  }

  String _seriesSubtitle(SeriesModel series) {
    final totalMinutes = series.items.fold<int>(
      0,
      (sum, item) => sum + item.estimatedDuration.inMinutes,
    );
    final itemsLabel = '${series.itemCount} items';
    if (totalMinutes <= 0) return itemsLabel;
    return '$itemsLabel · ${AppFormate.formatReadDuration(Duration(minutes: totalMinutes))}';
  }

  Widget _buildViewedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            'Completed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
