import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/journal/providers/journal_provider.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/utils/basic_function.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/gratiude_journal_model.dart';

class CustomMonthCalender extends StatefulWidget {
  final JournalProvider provider;
  const CustomMonthCalender({super.key, required this.provider});

  @override
  State<CustomMonthCalender> createState() => _CustomMonthCalenderState();
}

class _CustomMonthCalenderState extends State<CustomMonthCalender> {
  static String _dayKey(DateTime d) =>
      '${d.year}-${d.month}-${d.day}';

  /// Minimum weeks needed to display every day of the current month.
  int _weeksInMonth() {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    // Sunday-based offset: Sunday=0, Mon=1 ... Sat=6
    final startOffset = firstOfMonth.weekday % 7;
    return ((startOffset + daysInMonth) / 7).ceil();
  }

  GratiudeJournalModel _journalForDay(
    DateTime day,
    Map<String, GratiudeJournalModel> byDay,
  ) {
    return byDay[_dayKey(day)] ??
        GratiudeJournalModel(
          id: '',
          profileId: '',
          emotion: '',
          emotionDescription: '',
          accomplishments: [],
          date: day,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final byDay = <String, GratiudeJournalModel>{};
    for (final j in widget.provider.gratitudeJournals) {
      byDay[_dayKey(j.date)] = j;
    }

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
          ClipRect(
            child: SizedBox(
              height: _weeksInMonth() * 80.0 + 40,
              child: OverflowBox(
                maxHeight: 6 * 80.0 + 40,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 6 * 80.0 + 40,
                  child: SfCalendar(
              onTap: (calendarTapDetails) {
                final tappedDate = calendarTapDetails.date;
                if (tappedDate == null) return;
                final journal = _journalForDay(tappedDate, byDay);
                if (journal.id.isEmpty) {
                  widget.provider.navigateToCreateJournal();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return JournalDetailScreen(
                        gratitudeJournal: journal,
                        gratitudeId: journal.id,
                        journalProvider: widget.provider,
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

              // Custom cell draws selection; disable default border/fill.
              todayHighlightColor: AppColors.primary,
              selectionDecoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border.fromBorderSide(BorderSide.none),
              ),

              cellBorderColor: Colors.transparent,
              viewHeaderStyle: ViewHeaderStyle(
                dayTextStyle: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              monthViewSettings: MonthViewSettings(
                dayFormat: 'EEEEE',
                numberOfWeeksInView: 6,
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

                final journal = _journalForDay(details.date, byDay);

                final cellContent = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow:
                            !isToday
                                ? null
                                : [
                                  BoxShadow(
                                    color: HexColor('#6E40F9').withValues(
                                      alpha: 0.16,
                                    ),
                                    blurRadius: 7,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                      ),
                      child:
                          journal.id.isNotEmpty
                              ? SvgPicture.asset(
                                BasicFunction.getJounalEmoji(journal.emotion),
                                width: 24,
                                height: 24,
                              )
                              : Opacity(
                                opacity: 0.25,
                                child: SvgPicture.asset(
                                  Assets.icons.happy,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
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

                return cellContent;
              },
            ),
          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
