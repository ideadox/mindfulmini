import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class BreathingScreen extends StatelessWidget {
  static String routeName = 'breadthing-main';
  static String routePath = '/breadthing-main';

  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return CollectionDiscoverScreen(
      collectionSlug: 'breathing',
      title: strings.breathing('screen.title', fallback: 'Breathing Exercise'),
      subtitle: strings.breathing(
        'screen.subtitle',
        fallback: 'Blow away worries with each mindful breath.',
      ),
      headerImage: Assets.images.breathingTopHeader.path,
    );
  }
}
