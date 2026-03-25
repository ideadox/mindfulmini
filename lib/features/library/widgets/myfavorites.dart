import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/library/models/favorite_item.dart';
import 'package:mindfulminis/features/library/providers/library_provider.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import 'library_empty_data.dart';

class Myfavorites extends StatelessWidget {
  const Myfavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sl<LibraryProvider>(),
      builder: (context, _) {
        final provider = sl<LibraryProvider>();

        if (provider.favoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.favorites.isEmpty) {
          return const MyFavEmpty();
        }

        final grouped = provider.favoritesByCollection;

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: grouped.length,
          separatorBuilder: (_, __) => Space.h20,
          itemBuilder: (context, index) {
            final collection = grouped.keys.elementAt(index);
            final items = grouped[collection]!;
            return _FavoriteSection(
              collectionName: FavoriteItem.collectionDisplayName(collection),
              collection: collection,
              items: items,
            );
          },
        );
      },
    );
  }
}

class _FavoriteSection extends StatelessWidget {
  const _FavoriteSection({
    required this.collectionName,
    required this.collection,
    required this.items,
  });

  final String collectionName;
  final String collection;
  final List<FavoriteItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Space.h16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  '$collectionName Liked',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${items.length}',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Space.h16,
          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => Space.w12,
              itemBuilder: (context, index) {
                return _FavoriteCard(item: items[index]);
              },
            ),
          ),
          Space.h16,
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.item});

  final FavoriteItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        sl<GoRouter>().pushNamed(
          PlayVisuals.routeName,
          queryParameters: {
            'collection': item.collection,
            'id': item.contentId,
          },
        );
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: item.thumbnailUrl != null
                        ? CachedNetworkImage(
                            imageUrl: item.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: Colors.grey.shade200,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.music_note_rounded,
                                  color: Colors.grey),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.music_note_rounded,
                                color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Space.h8,
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFavEmpty extends StatelessWidget {
  const MyFavEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return LibraryEmptyData(
      icon: Assets.images.myfavImg.path,
      title: "You haven't favorited any tracks",
      subtitle: 'Tap on the heart icon to add your favourite content to this list',
      space: true,
    );
  }
}
