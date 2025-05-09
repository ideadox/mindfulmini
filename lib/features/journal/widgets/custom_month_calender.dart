import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomMonthCalender extends StatelessWidget {
  const CustomMonthCalender({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Today ${DateFormat('d MMM yyyy').format(DateTime.now())}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              // DropdownButton<String>(
              //   value: 'Option 1',
              //   underline: SizedBox(),
              //   items:
              //       <String>[
              //         'Option 1',
              //         'Option 2',
              //         'Option 3',
              //       ].map<DropdownMenuItem<String>>((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              //   onChanged: (value) {
              //     // handle dropdown change
              //   },
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 370,
          child: SfCalendar(
            initialSelectedDate: DateTime.now(),
            firstDayOfWeek: 7,
            view: CalendarView.month,
            showDatePickerButton: false,
            headerHeight: 0,
            todayHighlightColor: Colors.transparent,
            cellBorderColor: Colors.transparent,
            monthViewSettings: MonthViewSettings(
              dayFormat: 'EEE',
              numberOfWeeksInView: 5,

              showAgenda: false,
              appointmentDisplayMode: MonthAppointmentDisplayMode.none,
              monthCellStyle: MonthCellStyle(
                textStyle: TextStyle(color: AppColors.primary),
              ),
            ),
            monthCellBuilder: (BuildContext context, MonthCellDetails details) {
              final bool isToday =
                  details.date.day == DateTime.now().day &&
                  details.date.month == DateTime.now().month &&
                  details.date.year == DateTime.now().year;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    details.date.day.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isToday ? Colors.purple : Colors.black87,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
