import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/journal/providers/journal_provider.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail1_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomMonthCalender extends StatelessWidget {
  final JournalProvider provider;
  const CustomMonthCalender({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
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
          Space.h20,
          SizedBox(
            height: 450,
            child: SfCalendar(
              onTap: (calendarTapDetails) {
                // provider.navigateToJournalDetail();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return JournalDetail1Screen();
                    },
                  ),
                );
                return;
              },
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

                      padding: !isToday ? null : EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(100),
                        border:
                            !isToday
                                ? null
                                : Border.all(color: AppColors.primary),
                      ),
                      child:
                          !isToday
                              ? null
                              : SvgPicture.asset(Assets.icons.amazingEmoji),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: double.infinity,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient:
                            !isToday
                                ? null
                                : LinearGradient(
                                  colors: [
                                    HexColor('#6E40F9'),
                                    HexColor('#A569FB'),
                                    HexColor('#CE89FF'),
                                  ],
                                ),
                      ),
                      child: Text(
                        details.date.day.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              isOtherMonth
                                  ? Colors.grey
                                  : isToday
                                  ? Colors.white
                                  : Colors.black87,
                        ),
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
