import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/analytices/widgets/week_widgets/gradint_circular_indicator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../../core/app_spacing.dart';

class OverallCalenderView extends StatelessWidget {
  const OverallCalenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
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
              firstDayOfWeek: 7,
              view: CalendarView.month,
              showDatePickerButton: false,
              headerHeight: 0,

              todayHighlightColor: Colors.black,
              cellBorderColor: Colors.transparent,
              monthViewSettings: MonthViewSettings(
                dayFormat: 'EEE',
                numberOfWeeksInView: 5,

                appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                // monthCellStyle: MonthCellStyle(
                //   textStyle: TextStyle(color: AppColors.primary),
                // ),
              ),
              monthCellBuilder: (
                BuildContext context,
                MonthCellDetails details,
              ) {
                final bool lessThanDay =
                    details.date.day <= DateTime.now().day &&
                    details.date.month == DateTime.now().month;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child:
                          lessThanDay
                              ? GradientCircularIndicator(
                                percent: 0.75,
                                radius: 20,
                                lineWidth: 3,
                                gradientColors:
                                    AppColors.primaryGradientColors.reversed
                                        .toList(),
                                centerText: details.date.day.toString(),
                              )
                              : Text(
                                details.date.day.toString(),
                                style: TextStyle(color: Colors.black54),
                              ),
                    ),
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
