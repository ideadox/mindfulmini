import 'package:flutter/material.dart';
import 'package:mindfulminis/common/screens/collection_discover_screen.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

/// Same pattern as [BreathingScreen], [MeditationScreen], [YogaMain]: thin route
/// that wraps [CollectionDiscoverScreen] (header image, back button, grid).
class MiniBodyScanScreen extends StatelessWidget {
  static String routeName = 'mini-body-scan';
  static String routePath = '/mini-body-scan';

  const MiniBodyScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return CollectionDiscoverScreen(
      collectionSlug: 'minibodyscans',
      title: strings.home('body_scan.title', fallback: 'Mini Body Scan'),
      subtitle: strings.home(
        'body_scan.subtitle',
        fallback: 'Let’s explore your magical body, one part at a time.',
      ),
      headerImage: Assets.images.minibodyscanTopBackground.path,
    );
  }
}
