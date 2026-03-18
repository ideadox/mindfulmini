import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class BreathingScreen extends StatelessWidget {
  static String routeName = 'breadthing-main';
  static String routePath = '/breadthing-main';

  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CollectionDiscoverScreen(
      collectionSlug: 'breathing',
      title: 'Breathing Exercise',
      subtitle: 'Blow away worries with each mindful breath.',
      headerImage: Assets.images.breathingTopHeader.path,
    );
  }
}
