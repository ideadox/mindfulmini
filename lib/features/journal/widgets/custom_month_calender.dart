import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/features/journal/providers/journal_provider.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail1_screen.dart';
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
  DateTime? _tooltipDate;

  bool _isSameDate(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month && a.year == b.year;
  }

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
                final tappedDate = calendarTapDetails.date;
                if (tappedDate == null) return;
                final journal = widget.provider.gratitudeJournals.lastWhere(
                  (element) {
                    return element.date.day == tappedDate.day &&
                        element.date.month == tappedDate.month &&
                        element.date.year == tappedDate.year;
                  },
                  orElse:
                      () => GratiudeJournalModel(
                        id: '',
                        profileId: '',

                        emotion: '',
                        emotionDescription: '',
                        accomplishments: [],
                        date: tappedDate,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                );
                if (journal.id.isEmpty) {
                  setState(() {
                    _tooltipDate =
                        _tooltipDate != null &&
                                _isSameDate(_tooltipDate!, tappedDate)
                            ? null
                            : tappedDate;
                  });
                  return;
                }
                setState(() {
                  _tooltipDate = null;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return JournalDetail1Screen(
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
              todayHighlightColor: Colors.transparent,
              selectionDecoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border.fromBorderSide(BorderSide.none),
              ),

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

                final journal = widget.provider.gratitudeJournals.lastWhere(
                  (element) {
                    return element.date.day == details.date.day &&
                        element.date.month == details.date.month &&
                        element.date.year == details.date.year;
                  },
                  orElse:
                      () => GratiudeJournalModel(
                        id: '',
                        profileId: '',

                        emotion: '',
                        emotionDescription: '',
                        accomplishments: [],
                        date: details.date,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                );
                final showTooltip =
                    _tooltipDate != null && _isSameDate(_tooltipDate!, details.date);
                final isSelected =
                    isToday ||
                    (_tooltipDate != null &&
                        _isSameDate(_tooltipDate!, details.date));

                final cellContent = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow:
                            !isSelected
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

                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    cellContent,
                    if (showTooltip)
                      Positioned(
                        top: -112,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: 210,
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Tap a day to log your mood and track your happiness journey over time.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 30,
                                  width: 90,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6E40F9),
                                          Color(0xFFA569FB),
                                          Color(0xFFCE89FF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _tooltipDate = null;
                                        });
                                      },
                                      child: const Text(
                                        'Got it!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
