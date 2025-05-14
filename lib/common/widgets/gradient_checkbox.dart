import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GradientCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GradientCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient:
                value
                    ? LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        HexColor('#6E40F9'),
                        HexColor('#A569FB'),
                        HexColor('#CE89FF'),
                      ],
                    )
                    : null,
            border: Border.all(
              color: value ? Colors.transparent : Colors.grey.shade400,
              width: 2,
            ),
            color: value ? null : Colors.transparent,
          ),
          child:
              value ? Icon(Icons.check, color: Colors.white, size: 16) : null,
        ),
      ),
    );
  }
}
