import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/common_appbar.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/routine/screens/create_routine_screen.dart';
import 'package:mindfulminis/features/routine/screens/routine_detail_screen.dart';
import 'package:mindfulminis/features/routine/widgets/myroutine_brief_card.dart';
import 'package:mindfulminis/injection/injection.dart';

class MyRoutineScreen extends StatelessWidget {
  static String routeName = 'myroutine-screen';
  static String routePath = '/myroutine-screen';

  const MyRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Space.h20,
          CommonAppbar(
            title: Text(
              'My Routine',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(12),
              itemCount: 2,
              separatorBuilder: (context, index) => Space.h32,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    sl<GoRouter>().pushNamed(RoutineDetailScreen.routeName);
                  },
                  child: MyroutineBriefCard(),
                );
              },
            ),
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
    );
  }
}
