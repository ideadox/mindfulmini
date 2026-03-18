import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/features/stories/proviers/sroties_provider.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

import '../../play_visuals/screen/play_visuals.dart';

class ShortStories extends StatelessWidget {
  const ShortStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SrotiesProvider>(
      builder: (context, storiesProvider, _) {
        if (storiesProvider.storiesSessions.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 100 / 140,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final story = storiesProvider.storiesSessions[index];
              return InkWell(
                onTap: () {
                  sl<GoRouter>().pushNamed(
                    PlayVisuals.routeName,
                    queryParameters: {
                      'collection': 'stories',
                      'id': story.id,
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        Uri.encodeFull(
                          '${ApiConstants.mediaBaseUrl}${story.cardImageFilename ?? ''}',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: storiesProvider.storiesSessions.length),
          ),
        );
      },
    );
  }
}
