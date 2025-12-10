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

class MyRoutineBaseScreen extends StatelessWidget {
  const MyRoutineBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<RoutineProvider>();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Space.h32,
              CommonAppbar(
                applyLeading: false,
                title: Text(
                  'My Routine',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              // Space.h20,
              Expanded(
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
                ),
              ),

              SizedBox(height: 80),
            ],
          ),

          Positioned(
            bottom: 100,
            right: 30,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                await sl<GoRouter>().pushNamed(CreateRoutineScreen.routeName);
                if (context.mounted) {
                  provider.getRoutines(notify: false);
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
        ],
      ),
    );
  }
}
