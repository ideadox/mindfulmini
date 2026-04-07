import 'package:flutter/material.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/remote_config_service.dart';
import 'package:provider/provider.dart';

import '../../profile/providers/profile_provider.dart';
import '../providers/routine_provider.dart';
import '../widgets/routine_shimmer_loader.dart';
import 'my_routine_base_screen.dart';
import 'routine_screen.dart';

class RoutineDecider extends StatelessWidget {
  const RoutineDecider({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = sl<RemoteConfigService>().strings;
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        if (profileProvider.loading || profileProvider.userProfile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profileId = profileProvider.userProfile!.id;

        return ChangeNotifierProvider(
          create: (context) => RoutineProvider(profileId),
          builder: (context, child) => child!,
          child: Consumer<RoutineProvider>(
            builder: (context, p, _) {
              if (p.loading) {
                return const Scaffold(body: RoutineShimmerLoader());
              }
              if (p.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        strings.routine(
                          'decider.load_error_title',
                          fallback: 'Failed to load routines',
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => p.getRoutines(),
                        child: Text(
                          strings.routine('decider.retry_cta', fallback: 'Retry'),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (p.routines.isNotEmpty) {
                return MyRoutineBaseScreen();
              }
              return RoutineScreen();
            },
          ),
        );
      },
    );
  }
}
