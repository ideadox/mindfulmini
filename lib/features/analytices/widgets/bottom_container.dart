import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      // margin: EdgeInsets.only(top: 200),
      child: Stack(
        children: [
          SvgPicture.asset(Assets.profileIcons.analyBottom),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SvgPicture.asset(Assets.profileIcons.analyBottom1),
          ),
        ],
      ),
    );
  }
}
