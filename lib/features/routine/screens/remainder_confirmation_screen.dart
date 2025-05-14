import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/scroll_timepicker.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/routine/providers/create_routine_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class RemainderConfirmationScreen extends StatelessWidget {
  final CreateRoutineProvider provider;
  const RemainderConfirmationScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    Widget buildStepper() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(5, (index) {
          final isActive = index == 4;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: isActive ? 32 : 12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  HexColor('#6E40F9'),
                  HexColor('#A569FB'),
                  HexColor('#CE89FF'),
                ],
              ),
              color: isActive ? null : Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          );
        }),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  CustomBackButton(hasBackground: true),
                  SizedBox(width: 48),
                ],
              ),

              Center(child: buildStepper()),
            ],
          ),
          Space.h20,
          Text(
            'No Reminder',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Space.h40,
          ScrollTimePicker(
            onTimeChanged: (p0) {
              log(p0.toString());
            },
          ),
          Space.h40,
          Row(children: [Text('Select Day')]),
          Space.h24,

          BuildWeekDay(),
          Space.h24,

          Container(
            child: ListTile(
              leading: SvgPicture.asset(Assets.icons.rimderIcon),
              title: Text('Reminder'),
              subtitle: Text('Set a specific time to remind me  '),
              trailing: CupertinoSwitch(value: false, onChanged: (val) {}),
            ),
          ),
          Space.h24,

          GradientButton(
            onPressed: () {
              provider.showSuccessDailog();
            },
            child: Center(
              child: Text(
                'Save',
                style: AppTextTheme.mainButtonTextStyle(context).titleLarge,
              ),
            ),
          ),
          Space.h24,
        ],
      ),
    );
  }
}

class BuildWeekDay extends StatefulWidget {
  const BuildWeekDay({super.key});

  @override
  State<BuildWeekDay> createState() => _BuildWeekDayState();
}

class _BuildWeekDayState extends State<BuildWeekDay> {
  final List<String> weekDay = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  final List<String> selectedDay = [];

  void updateSelection(val) {
    setState(() {
      if (selectedDay.contains(val)) {
        selectedDay.remove(val);
      } else {
        selectedDay.add(val);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          weekDay.map((val) {
            return InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                updateSelection(val);
              },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient:
                      !selectedDay.contains(val)
                          ? null
                          : LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              HexColor('#6E40F9'),
                              HexColor('#A569FB'),
                              HexColor('#CE89FF'),
                            ],
                          ),
                  border: Border.all(color: AppColors.purple, width: 1),
                ),
                child: Text(
                  val[0],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color:
                        selectedDay.contains(val)
                            ? Colors.white
                            : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
