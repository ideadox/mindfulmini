import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class YogaMain extends StatelessWidget {
  static String routeName = 'yoga-main';
  static String routePath = '/yoga-main';

  const YogaMain({super.key});

  @override
  Widget build(BuildContext context) {
    return CollectionDiscoverScreen(
      collectionSlug: 'yoga',
      title: 'Yoga',
      subtitle:
          'Inspire movement, balance, and joyful focus through playful poses.',
      headerImage: Assets.images.yogaTopBackgroud.path,
    );
  }
}
