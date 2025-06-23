import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class HorizontalWeekCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  

  const HorizontalWeekCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToSelected());
  }

  void scrollToSelected() {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    int selectedIndex = widget.selectedDate.difference(startOfWeek).inDays;

    if (selectedIndex >= 0 && selectedIndex < 7) {
      double itemWidth = 62 + 12;
      _scrollController.animateTo(
        selectedIndex * itemWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didUpdateWidget(covariant HorizontalWeekCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      scrollToSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return SizedBox(
      height: 90,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (context, index) {
          return Space.w12;
        },
        itemBuilder: (context, index) {
          DateTime date = startOfWeek.add(Duration(days: index));
          bool isSelected =
              date.day == widget.selectedDate.day &&
              date.month == widget.selectedDate.month &&
              date.year == widget.selectedDate.year;

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: 62,
              height: 90,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? HexColor('#DCC6FF') : Colors.white,
                borderRadius: BorderRadius.circular(300),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),
                  Text(
                    DateFormat.E().format(date), // e.g., Mon
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
