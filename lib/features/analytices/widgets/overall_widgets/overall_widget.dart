import 'package:flutter/material.dart';
import 'package:mindfulminis/core/app_spacing.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

import 'overall_anayl_card.dart';
import 'overall_build_routine_card.dart';

class OverallWidget extends StatelessWidget {
  const OverallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          bottom: -300,
          child: Image.asset(
            Assets.vectors.todayAnaylBg.path,
            fit: BoxFit.fill,
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [OverallAnaylCard(), Space.h20]),
          ),
        ),
      ],
    );
  }
}
