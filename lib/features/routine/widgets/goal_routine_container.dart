import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_gradient_text.dart';
import 'package:mindfulminis/common/widgets/gradient_checkbox.dart';
import 'package:mindfulminis/core/app_colors.dart';

class GoalRoutineContainer extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final Function(bool) onChanged;
  const GoalRoutineContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: !isSelected ? null : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              gradient:
                  !isSelected
                      ? null
                      : LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color.fromARGB(255, 236, 230, 254),
                          const Color.fromARGB(255, 245, 243, 253),
                        ],
                      ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon),

                if (isSelected)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomGradientText(text: title, isBold: true),
                  ),
                if (!isSelected)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        Positioned(
          child: GradientCheckbox(
            value: isSelected,
            onChanged: (val) {
              onChanged(val);
            },
          ),
        ),
      ],
    );
  }
}
