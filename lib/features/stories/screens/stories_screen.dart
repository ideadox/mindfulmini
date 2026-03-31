import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class StoriesScreen extends StatelessWidget {
  static String routeName = 'stories-main';
  static String routePath = '/stories-main';

  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return CollectionDiscoverScreen(
      collectionSlug: 'stories',
      title: strings.stories('screen.title', fallback: 'Stories'),
      subtitle: strings.stories(
        'screen.subtitle',
        fallback: 'Spark imagination, curiosity, and emotional learning through tales.',
      ),
      headerImage: Assets.images.storyTopBackground.path,
    );
  }
}
