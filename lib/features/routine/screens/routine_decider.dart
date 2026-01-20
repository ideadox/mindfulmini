import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../profile/providers/profile_provider.dart';
import '../providers/routine_provider.dart';
import 'my_routine_base_screen.dart';
import 'routine_screen.dart';

class RoutineDecider extends StatelessWidget {
  const RoutineDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        if (profileProvider.loading || profileProvider.userProfile == null) {
          return Center(child: CircularProgressIndicator());
        }

        final profileId = profileProvider.userProfile!.id;

        return ChangeNotifierProvider(
      create: (context) => RoutineProvider(profileId),

      builder: (context, child) {
        return child!;
      },

      child: Consumer<RoutineProvider>(
        builder: (context, p, _) {
          if (p.loading) {
            return Center(child: CircularProgressIndicator());
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
