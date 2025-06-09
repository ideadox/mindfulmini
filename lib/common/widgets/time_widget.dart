import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class TimeWidget extends StatelessWidget {
  final int totalTime;
  const TimeWidget({super.key, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.icons.timer, height: 16, width: 16),
          Space.w4,
          Text('${totalTime.toString()}m', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
