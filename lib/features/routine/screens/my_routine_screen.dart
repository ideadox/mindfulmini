import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/common_appbar.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/profile/providers/profile_provider.dart';
import 'package:mindfulminis/features/routine/providers/routine_provider.dart';
import 'package:mindfulminis/features/routine/screens/create_routine_screen.dart';
import 'package:mindfulminis/features/routine/screens/routine_detail_screen.dart';
import 'package:mindfulminis/features/routine/widgets/extend_routine_sheet.dart';
import 'package:mindfulminis/features/routine/widgets/myroutine_brief_card.dart';
import 'package:mindfulminis/features/routine/widgets/routine_shimmer_loader.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:provider/provider.dart';

class MyRoutineScreen extends StatelessWidget {
  static String routeName = 'myroutine-screen';
  static String routePath = '/myroutine-screen';

  const MyRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        if (profileProvider.loading || profileProvider.userProfile == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profileId = profileProvider.userProfile!.id;
        return ChangeNotifierProvider(
      create: (context) => RoutineProvider(profileId),
      child: Scaffold(
        body: Column(
          children: [
            Space.h20,
            CommonAppbar(
              title: Text(
                'My Routine',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            Consumer<RoutineProvider>(
              builder: (context, provider, _) {
                if (provider.loading) {
                  return const Expanded(
                    child: RoutineShimmerLoader(),
                  );
                }
                // Bulletproof: if routines loaded but progress not yet fetched
                if (provider.routines.isNotEmpty &&
                    provider.routineProgress.isEmpty) {
                  Future.microtask(() => provider.refreshProgress());
                }
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await provider.getRoutines(notify: false);
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.all(12),
                      itemCount: provider.routines.length,
                      separatorBuilder: (context, index) => Space.h32,
                      itemBuilder: (context, index) {
                        final routineModel = provider.routines[index];
                        final progress =
                            provider.routineProgress[routineModel.id];
                        final isExpired =
                            routineModel.dayNumberSinceStart() >=
                            routineModel.durationDays;
                        return InkWell(
                          onTap: () async {
                            if (context.mounted) {
                              if (isExpired) {
                                final result = await showExtendRoutineSheet(
                                  context,
                                  routineModel,
                                );
                                if (result != null) {
                                  provider.getRoutines(notify: false);
                                }
                              } else {
                                await sl<GoRouter>().pushNamed(
                                  RoutineDetailScreen.routeName,
                                  pathParameters: {'routineId': routineModel.id},
                                  extra: routineModel,
                                );
                                provider.refreshProgress();
                              }
                            }
                          },
                          child: MyroutineBriefCard(
                            routineModel: routineModel,
                            activityProgress: progress,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        floatingActionButton: InkWell(
          borderRadius: BorderRadius.circular(100),

          onTap: () async {
            await sl<GoRouter>().pushNamed(CreateRoutineScreen.routeName);
            if (context.mounted) {
              context.read<RoutineProvider>().getRoutines(notify: false);
            }
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: AppColors.primaryGradient,
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
      },
    );
  }
}
