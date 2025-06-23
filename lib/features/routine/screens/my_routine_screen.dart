import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/common_appbar.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/routine/providers/routine_provider.dart';
import 'package:mindfulminis/features/routine/screens/create_routine_screen.dart';
import 'package:mindfulminis/features/routine/screens/routine_detail_screen.dart';
import 'package:mindfulminis/features/routine/widgets/myroutine_brief_card.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:provider/provider.dart';

class MyRoutineScreen extends StatelessWidget {
  static String routeName = 'myroutine-screen';
  static String routePath = '/myroutine-screen';

  const MyRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoutineProvider(),
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
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(12),
                    itemCount: provider.routines.length,
                    separatorBuilder: (context, index) => Space.h32,
                    itemBuilder: (context, index) {
                      final routineModel = provider.routines[index];
                      return InkWell(
                        onTap: () {
                          sl<GoRouter>().pushNamed(
                            RoutineDetailScreen.routeName,
                            pathParameters: {'routineId': routineModel.id},
                          );
                        },
                        child: MyroutineBriefCard(routineModel: routineModel),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),

        floatingActionButton: InkWell(
          borderRadius: BorderRadius.circular(100),

          onTap: () {
            sl<GoRouter>().pushNamed(CreateRoutineScreen.routeName);
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
  }
}
