import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';

class HorizontalAnalyticDay extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const HorizontalAnalyticDay({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<HorizontalAnalyticDay> createState() => _HorizontalAnalyticDayState();
}

class _HorizontalAnalyticDayState extends State<HorizontalAnalyticDay> {
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
      double itemWidth = 73 + 12;
      _scrollController.animateTo(
        selectedIndex * itemWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didUpdateWidget(covariant HorizontalAnalyticDay oldWidget) {
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
      height: 73,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (context, index) {
          return Space.w4;
        },
        itemBuilder: (context, index) {
          DateTime date = startOfWeek.add(Duration(days: index));
          DateTime today = DateTime.now();

          bool isSelected =
              date.day == widget.selectedDate.day &&
              date.month == widget.selectedDate.month &&
              date.year == widget.selectedDate.year;

          bool isPast = date.isBefore(
            DateTime(today.year, today.month, today.day),
          );
          bool isToday =
              date.day == today.day &&
              date.month == today.month &&
              date.year == today.year;
          bool isFuture = date.isAfter(
            DateTime(today.year, today.month, today.day),
          );

          // Determine icon and background color
          BoxDecoration iconDecoration;
          Widget? iconChild;

          if (isPast) {
            iconDecoration = BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(100),
            );
            iconChild = Icon(Icons.check, color: Colors.white, size: 15);
          } else if (isToday) {
            iconDecoration = BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            );
            iconChild = null;
          } else {
            iconDecoration = BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(100),
            );
            iconChild = null;
          }

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: 43,
              height: 73,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: isSelected ? HexColor('#F0EBFF') : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    alignment: Alignment.center,
                    decoration: iconDecoration,
                    child: iconChild,
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
