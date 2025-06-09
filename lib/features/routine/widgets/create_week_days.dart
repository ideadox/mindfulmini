import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/core/app_colors.dart';

import '../providers/remainder_routine_provider.dart';

class CreateWeekDays extends StatelessWidget {
  final bool disable;
  final RemainderRoutineProvider rProvider;
  const CreateWeekDays({
    super.key,
    required this.rProvider,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          rProvider.weekDay.map((val) {
            return InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap:
                  disable
                      ? null
                      : () {
                        rProvider.updateSelection(val);
                      },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient:
                      !rProvider.selectedDay.contains(val)
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
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  val[0],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color:
                        rProvider.selectedDay.contains(val)
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
