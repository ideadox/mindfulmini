import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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

  final itemExtent = 50.0;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: (itemExtent * 2),
                  left: 0,
                  right: 0,
                  height: itemExtent,
                  child: Column(
                    children: [
                      Container(
                        height: 2,
                        decoration: BoxDecoration(color: HexColor('#CE89FF')),
                      ),
                      Spacer(),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(color: HexColor('#6E40F9')),
                      ),
                    ],
                  ),
                ),
                ListWheelScrollView.useDelegate(
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
                          (index + 1).toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: isSelected ? 16 : 14,

                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    },
                    childCount: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: (itemExtent * 2),
                  left: 0,
                  right: 0,
                  height: itemExtent,
                  child: Column(
                    children: [
                      Container(
                        height: 2,
                        decoration: BoxDecoration(color: HexColor('#CE89FF')),
                      ),
                      Spacer(),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(color: HexColor('#6E40F9')),
                      ),
                    ],
                  ),
                ),
                ListWheelScrollView.useDelegate(
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
                            fontSize: isSelected ? 16 : 14,

                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      );
                    },
                    childCount: 60,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // AM/PM Picker
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: (itemExtent * 2),
                  left: 0,
                  right: 0,
                  height: itemExtent,
                  child: Column(
                    children: [
                      Container(
                        height: 2,
                        decoration: BoxDecoration(color: HexColor('#CE89FF')),
                      ),
                      Spacer(),
                      Container(
                        height: 2,
                        decoration: BoxDecoration(color: HexColor('#6E40F9')),
                      ),
                    ],
                  ),
                ),
                ListWheelScrollView.useDelegate(
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
                                fontSize: isSelected ? 16 : 14,

                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
