import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class MeditationScreen extends StatelessWidget {
  static String routeName = 'meditation-main';
  static String routePath = '/meditation-main';

  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CollectionDiscoverScreen(
      collectionSlug: 'meditation',
      title: 'Meditation',
      subtitle: 'A gentle pause for peace, smiles, and self-love.',
      headerImage: Assets.images.medatationTopBackground.path,
    );
  }
}
