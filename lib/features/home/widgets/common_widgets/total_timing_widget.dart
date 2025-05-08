import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class TotalTimingWidget extends StatelessWidget {
  const TotalTimingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white12),
      child: Row(
        children: [
          SvgPicture.asset(Assets.icons.timer, height: 16, width: 16),
          Text('30 sec', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
