import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mindfulminis/common/widgets/custom_back_button.dart';
import 'package:mindfulminis/common/widgets/gradient_button.dart';
import 'package:mindfulminis/common/widgets/scroll_timepicker.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/core/app_formate.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/core/app_text_theme.dart';
import 'package:mindfulminis/features/routine/providers/create_routine_provider.dart';
import 'package:mindfulminis/features/routine/providers/remainder_routine_provider.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:provider/provider.dart';

import '../widgets/create_week_days.dart';

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

    return ChangeNotifierProvider(
      create: (context) => RemainderRoutineProvider(),
      child: Consumer<RemainderRoutineProvider>(
        builder: (context, rProvider, _) {
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
                  rProvider.remainder && rProvider.selectedTime != null
                      ? 'Remind me at ${AppFormate.formatAMPM(rProvider.selectedTime!)}'
                      : 'No Reminder',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Space.h40,
                ScrollTimePicker(
                  disable: rProvider.remainder,
                  onTimeChanged: (p0) {
                    rProvider.updateTime(p0);
                  },
                ),
                Space.h40,
                Row(children: [Text('Select Day')]),
                Space.h24,

                CreateWeekDays(rProvider: rProvider),
                Space.h24,

                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.dividerColor),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,

                      colors: [HexColor('#F4F0FF'), HexColor('#FFFFFF')],
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(
                      right: 12,
                      top: 12,
                      bottom: 12,
                    ),
                    leading: SvgPicture.asset(Assets.icons.rimderIcon),
                    title: Text(
                      'Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Set a specific time to remind me',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey45,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                      activeTrackColor: AppColors.purple,
                      value: rProvider.remainder,
                      onChanged: (val) {
                        rProvider.toogleRemaider();
                      },
                    ),
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
                      style:
                          AppTextTheme.mainButtonTextStyle(context).titleLarge,
                    ),
                  ),
                ),
                Space.h24,
              ],
            ),
          );
        },
      ),
    );
  }
}
