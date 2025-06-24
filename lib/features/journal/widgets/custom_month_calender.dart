import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/journal/providers/journal_provider.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail1_screen.dart';
import 'package:mindfulminis/utiles/basic_function.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/gratiude_journal_model.dart';

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
              ],
            ),
          ),
          Space.h20,
          SizedBox(
            height: 450,
            child: SfCalendar(
              onTap: (calendarTapDetails) {
                final journal = provider.gratitudeJournals.lastWhere(
                  (element) {
                    return element.date.day == calendarTapDetails.date?.day &&
                        element.date.month == calendarTapDetails.date?.month &&
                        element.date.year == calendarTapDetails.date?.year;
                  },
                  orElse:
                      () => GratiudeJournalModel(
                        id: '',
                        profileId: '',
                        activityId: '',
                        emotion: '',
                        emotionDescription: '',
                        accomplishments: '',
                        date: calendarTapDetails.date ?? DateTime.now(),
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        v: 0,
                      ),
                );
                if (journal.id.isEmpty) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return JournalDetail1Screen(
                        gratitudeJournal: journal,
                        gratitudeId: journal.id,
                        journalProvider: provider,
                      );
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

                final journal = provider.gratitudeJournals.lastWhere(
                  (element) {
                    return element.date.day == details.date.day &&
                        element.date.month == details.date.month &&
                        element.date.year == details.date.year;
                  },
                  orElse:
                      () => GratiudeJournalModel(
                        id: '',
                        profileId: '',
                        activityId: '',
                        emotion: '',
                        emotionDescription: '',
                        accomplishments: '',
                        date: details.date,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        v: 0,
                      ),
                );

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
                          journal.id.isNotEmpty
                              ? SvgPicture.asset(
                                BasicFunction.getJounalEmoji(journal.emotion),
                                width: 24,
                                height: 24,
                              )
                              : null,
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
