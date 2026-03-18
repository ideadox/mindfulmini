import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class StoriesScreen extends StatelessWidget {
  static String routeName = 'stories-main';
  static String routePath = '/stories-main';

  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CollectionDiscoverScreen(
      collectionSlug: 'stories',
      title: 'Stories',
      subtitle:
          'Spark imagination, curiosity, and emotional learning through tales.',
      headerImage: Assets.images.storyTopBackground.path,
    );
  }
}
