import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/common_appbar.dart';

import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/analytices/widgets/week_widgets/week_anayl.dart';

import '../widgets/overall_widgets/overall_widget.dart';
import '../widgets/today_widgets/today_anayl.dart';

class AnalyticScreen extends StatelessWidget {
  static String routeName = 'analytices-screen';
  static String routePath = '/analytices-screen';

  const AnalyticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              alignment: Alignment.bottomCenter,

              decoration: BoxDecoration(
                color: HexColor('#F7F4FF'),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Space.h16,
                  CommonAppbar(
                    hasBackground: false,
                    title: Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            HexColor('#DCB8FF'),
                            HexColor('#DCB8FF').withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(300),
                      ),
                      tabs: [
                        Tab(text: 'Today'),
                        Tab(text: 'Week'),
                        Tab(text: 'Overall'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [TodayAnayl(), WeekAnayl(), OverallWidget()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
