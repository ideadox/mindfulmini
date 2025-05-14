import 'package:flutter/material.dart';

class ScrollTimePicker extends StatefulWidget {
  final Function(TimeOfDay) onTimeChanged;

  const ScrollTimePicker({super.key, required this.onTimeChanged});

  @override
  State<ScrollTimePicker> createState() => _ScrollTimePickerState();
}

class _ScrollTimePickerState extends State<ScrollTimePicker> {
  int _selectedHour = 1;
  int _selectedMinute = 0;
  String _selectedPeriod = 'AM';

  final itemExtent = 40.0;

  final FixedExtentScrollController hourController =
      FixedExtentScrollController();
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController();
  final FixedExtentScrollController periodController =
      FixedExtentScrollController();

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    periodController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final hour =
        _selectedPeriod == 'AM'
            ? (_selectedHour == 12 ? 0 : _selectedHour)
            : (_selectedHour == 12 ? 12 : _selectedHour + 12);
    widget.onTimeChanged(TimeOfDay(hour: hour, minute: _selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemExtent * 5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center Highlight Box
          Positioned(
            top: (itemExtent * 2),
            left: 0,
            right: 0,
            height: itemExtent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // Scrollable Pickers
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  controller: hourController,
                  itemExtent: itemExtent,
                  perspective: 0.002,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedHour = index + 1;
                      _updateTime();
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final isSelected = index + 1 == _selectedHour;
                      return Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    },
                    childCount: 12,
                  ),
                ),
              ),

              Expanded(
                child: ListWheelScrollView.useDelegate(
                  controller: minuteController,
                  itemExtent: itemExtent,
                  perspective: 0.002,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMinute = index;
                      _updateTime();
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final isSelected = index == _selectedMinute;
                      return Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    },
                    childCount: 60,
                  ),
                ),
              ),

              // AM/PM Picker
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  controller: periodController,
                  itemExtent: itemExtent,
                  perspective: 0.002,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedPeriod = index == 0 ? 'AM' : 'PM';
                      _updateTime();
                    });
                  },
                  childDelegate: ListWheelChildListDelegate(
                    children:
                        ['AM', 'PM'].map((period) {
                          final isSelected = period == _selectedPeriod;
                          return Center(
                            child: Text(
                              period,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }
}
