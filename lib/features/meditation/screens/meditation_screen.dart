import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class MeditationScreen extends StatelessWidget {
  static String routeName = 'meditation-main';
  static String routePath = '/meditation-main';

  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return CollectionDiscoverScreen(
      collectionSlug: 'meditation',
      title: strings.meditation('screen.title', fallback: 'Meditation'),
      subtitle: strings.meditation(
        'screen.subtitle',
        fallback: 'A gentle pause for peace, smiles, and self-love.',
      ),
      headerImage: Assets.images.medatationTopBackground.path,
    );
  }
}
