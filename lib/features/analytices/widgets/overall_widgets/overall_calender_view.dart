import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/analytices/widgets/week_widgets/gradint_circular_indicator.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/app_spacing.dart';

class OverallCalenderView extends StatelessWidget {
  const OverallCalenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                DateFormat('d MMM').format(DateTime.now()),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
            ],
          ),
          Space.h12,
          SizedBox(
            height: 350,
            child: SfCalendar(
              onTap: (calendarTapDetails) {},
              // initialSelectedDate: DateTime.now(),
              firstDayOfWeek: 7,
              view: CalendarView.month,
              showDatePickerButton: false,
              headerHeight: 0,

              todayHighlightColor: AppColors.primary,
              cellBorderColor: Colors.transparent,
              monthViewSettings: MonthViewSettings(
                dayFormat: 'EEE',
                numberOfWeeksInView: 5,

                appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(color: AppColors.primary),
                ),
              ),
              monthCellBuilder: (
                BuildContext context,
                MonthCellDetails details,
              ) {
                final bool isToday =
                    details.date.day == DateTime.now().day &&
                    details.date.month == DateTime.now().month &&
                    details.date.year == DateTime.now().year;
                final isOtherMonth =
                    details.date.month != details.visibleDates[10].month;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: GradientCircularIndicator(
                        percent: 0.75,
                        radius: 20,
                        lineWidth: 3,
                        gradientColors:
                            AppColors.primaryGradientColors.reversed.toList(),
                        centerText: details.date.day.toString(),
                      ),

                      // Text(details.date.day.toString()),
                    ),
                    // const SizedBox(height: 6),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 4),
                    //   width: double.infinity,
                    //   height: 18,
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     // gradient:
                    //     //     !isToday
                    //     //         ? null
                    //     //         : LinearGradient(
                    //     //           colors: [
                    //     //             HexColor('#6E40F9'),
                    //     //             HexColor('#A569FB'),
                    //     //             HexColor('#CE89FF'),
                    //     //           ],
                    //     //         ),
                    //   ),
                    //   // child: Text(
                    //   //   details.date.day.toString(),
                    //   //   style: TextStyle(
                    //   //     fontSize: 12,
                    //   //     fontWeight: FontWeight.w600,
                    //   //     color:
                    //   //         isOtherMonth
                    //   //             ? Colors.grey
                    //   //             : isToday
                    //   //             ? Colors.white
                    //   //             : Colors.black87,
                    //   //   ),
                    //   // ),
                    // ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
