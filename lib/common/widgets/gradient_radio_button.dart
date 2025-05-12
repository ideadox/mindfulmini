import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GradientRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  const GradientRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.width = 20,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: value == groupValue ? null : Colors.grey,
          shape: const CircleBorder(),
          gradient:
              value == groupValue
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
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                3.0,
              ), // 👈 Inner padding to create separation
              child: Container(
                decoration: ShapeDecoration(
                  shape: const CircleBorder(),
                  gradient:
                      value == groupValue
                          ? LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              HexColor('#6E40F9'),
                              HexColor('#9D9FE6'),
                              HexColor('#CFC0FF'),
                            ],
                          )
                          : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
