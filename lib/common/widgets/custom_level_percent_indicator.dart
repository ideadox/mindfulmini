import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomLevelPercentIndicator extends StatelessWidget {
  final double percent;
  const CustomLevelPercentIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow:
            percent == 1
                ? [
                  BoxShadow(
                    color: HexColor('#0FC09C').withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: Offset(0, 1),
                  ),
                ]
                : [],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            constraints: BoxConstraints(
              maxHeight: 48,
              maxWidth: 48,
              minHeight: 48,
              minWidth: 48,
            ),
            value: percent,
            strokeWidth: 2.5,
            color: percent == 1 ? HexColor('#0FC09C') : Colors.blue,
            backgroundColor: Colors.grey.shade300,
          ),
          Positioned(
            child:
                percent == 1
                    ? Icon(Icons.check, color: HexColor('#0FC09C'))
                    : Text(
                      '${(percent * 100).round()}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
