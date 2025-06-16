import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/custom_dailog.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class CreateRoutineProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();

  String? routineTimeLine;
  String? routineTime;
  String? routineSpendTime;
  List<String> routineTypes = [];

  bool remainder = false;

  void onChangeTimeLine(val) {
    routineTimeLine = val;
    notifyListeners();
  }

  void onChangeTime(val) {
    routineTime = val;
    notifyListeners();
  }

  void onChangeSpendTime(val) {
    routineSpendTime = val;
    notifyListeners();
  }

  void onChangeType(val) {
    if (routineTypes.contains(val)) {
      routineTypes.remove(val);
    } else {
      // if (routineTypes.length == 3) {
      //   return;
      // }
      routineTypes.add(val);
    }
    notifyListeners();
  }

  void toogleRemaider() {
    remainder = !remainder;
    notifyListeners();
  }

  showSuccessDailog() {
    SmartDialog.show(
      clickMaskDismiss: false,
      backType: SmartBackType.ignore,
      maskWidget: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.black12),
      ),
      builder: (context) {
        return CustomDailog(
          onNext: () {
            SmartDialog.dismiss();
            _navigationService.pop();
          },
          title: 'Your Routine is Ready!',
          subTitle:
              'Enjoy your personalized mindful moments every day. Let’s get started!',
          buttonText: 'Go To Routine',
        );
      },
    );
  }

  List<Map<String, String>> firstPageData = [
    {
      'icon': Assets.icons.routineCalenderIcon,
      'title': 'Kickstart',
      'subtitle': '30 Days',
    },
    {
      'icon': Assets.icons.routineCalenderIcon,
      'title': 'Habit Builder',
      'subtitle': '90 Days',
    },
    {
      'icon': Assets.icons.routineCalenderIcon,
      'title': 'Transformation',
      'subtitle': '180 Days',
    },
    {
      'icon': Assets.icons.routineCalenderIcon,
      'title': "Day's Mastery",
      'subtitle': '365 Days',
    },
  ];
  List<Map<String, String>> secondPageData = [
    {
      'icon': Assets.icons.sunIcon,
      'title': 'Rise and Shine',
      'subtitle': 'Morning',
    },
    {
      'icon': Assets.icons.fullSunIcon,
      'title': 'Midday Magic Moments',
      'subtitle': 'Afternoon',
    },
    {
      'icon': Assets.icons.sunDimIcon,
      'title': 'Twilight Adventure Hour',
      'subtitle': 'Evening',
    },
    {
      'icon': Assets.icons.moonIcon,
      'title': "Dreamland Serenity",
      'subtitle': 'Bed Time',
    },
  ];
  List<Map<String, String>> thirdPageData = [
    {'icon': Assets.icons.alarm, 'title': 'Quick', 'subtitle': '20-Min'},
    {'icon': Assets.icons.alarm, 'title': 'Focused', 'subtitle': '30-Min'},
    {'icon': Assets.icons.alarm, 'title': 'Productive', 'subtitle': '45-Min'},
    {
      'icon': Assets.icons.alarm,
      'title': "Mindful Mastery",
      'subtitle': '60-Min',
    },
  ];

  List<Map<String, String>> fourthPageData = [
    {'icon': Assets.images.meditationRoutine.path, 'title': 'Meditation'},
    {'icon': Assets.images.yogaRoutine.path, 'title': 'Yoga'},
    {'icon': Assets.images.breathRoutine.path, 'title': 'Breath'},
    {'icon': Assets.images.storyRoutine.path, 'title': "Story"},
    {'icon': Assets.images.miniBodyScanRoutine.path, 'title': "Mini Body Scan"},
  ];
}
