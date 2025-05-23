import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/bottom_container.dart';
import 'package:mindfulminis/features/analytices/widgets/daily_act_conatiner.dart';
import 'package:mindfulminis/features/analytices/widgets/horizontal_analytic_day.dart';
import 'package:mindfulminis/features/analytices/widgets/lession_container.dart';
import 'package:mindfulminis/features/analytices/widgets/streak_row.dart';

class AnalyticScreen extends StatelessWidget {
  static String routeName = 'analytices-screen';
  static String routePath = '/analytices-screen';

  const AnalyticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text('Analytics'),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  HorizontalAnalyticDay(
                    selectedDate: DateTime.now(),
                    onDateSelected: (value) {},
                  ),
                  Space.h20,
                  StreakRow(),
                  Space.h20,

                  DailyActConatiner(),
                  Space.h20,

                  LessionContainer(),
                ],
              ),
            ),
            SizedBox(height: 200),
            BottomContainer(),
          ],
        ),
      ),
    );
  }
}
