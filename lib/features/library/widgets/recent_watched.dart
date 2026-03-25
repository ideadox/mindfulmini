import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/library/models/recent_viewed_item.dart';
import 'package:mindfulminis/features/library/providers/library_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import 'library_empty_data.dart';

class RecentWatched extends StatelessWidget {
  const RecentWatched({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sl<LibraryProvider>(),
      builder: (context, _) {
        final provider = sl<LibraryProvider>();

        if (provider.recentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.recentlyViewed.isEmpty) {
          return const RecentWatchedEmpty();
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: provider.recentlyViewed.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return _RecentViewedCard(item: provider.recentlyViewed[index]);
          },
        );
      },
    );
  }
}

class _RecentViewedCard extends StatelessWidget {
  const _RecentViewedCard({required this.item});

  final RecentViewedItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      onTap: () {
        sl<GoRouter>().pushNamed(
          PlayVisuals.routeName,
          queryParameters: {
            'collection': item.collection,
            'id': item.contentId,
          },
        );
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 64,
          height: 64,
          child: item.thumbnailUrl != null
              ? CachedNetworkImage(
                  imageUrl: item.thumbnailUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: Colors.grey.shade200),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.music_note_rounded,
                        color: Colors.grey, size: 24),
                  ),
                )
              : Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.music_note_rounded,
                      color: Colors.grey, size: 24),
                ),
        ),
      ),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Space.h4,
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.collectionLabel,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              Space.w8,
              Text(
                _timeAgo(item.viewedAt),
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
          if (item.completionPercent > 0) ...[
            Space.h4,
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: item.completionPercent / 100.0,
                minHeight: 3,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  item.completionPercent >= 100
                      ? Colors.green
                      : Colors.deepPurple.shade300,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: const Icon(Icons.play_circle_outline_rounded,
          color: Colors.black38, size: 28),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}

class RecentWatchedEmpty extends StatelessWidget {
  const RecentWatchedEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return LibraryEmptyData(
      icon: Assets.images.recentlyWatched.path,
      title: "You haven't viewed any tracks\nrecently",
      subtitle: 'Explore and play tracks to see them here',
    );
  }
}
