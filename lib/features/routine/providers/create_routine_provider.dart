import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/common/widgets/custom_dailog.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../services/shared_prefs.dart';
import '../routine_data/routine_data.dart';

class CreateRoutineProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final _routineData = sl<RoutineData>();
  final _sharedPrefs = sl<SharedPrefs>();

  String? durationDays;
  String? timeOfDay;
  String? dailyDurationMinutes;
  List<String> goals = [];

  bool remainder = false;
  bool loading = false;
  bool creating = false;

  final String profileId;
  CreateRoutineProvider(this.profileId);

  //peroid
  void onChangeTimeLine(val) {
    log(val.toString());
    durationDays = val;
    notifyListeners();
  }

  //session
  void onChangeTime(val) {
    log(val.toString());

    timeOfDay = val;
    notifyListeners();
  }

  //duration
  void onChangeSpendTime(val) {
    log(val.toString());

    dailyDurationMinutes = val;
    notifyListeners();
  }

  //goals
  void onChangeType(val) {
    log(val.toString());

    if (goals.contains(val)) {
      goals.remove(val);
    } else {
      goals.add(val);
    }
    notifyListeners();
  }

  //remainder
  void toogleRemaider() {
    remainder = !remainder;
  }

  TimeOfDay? selectedTime = TimeOfDay(hour: 1, minute: 00);
  final List<String> selectedDay = [];

  void updateTime(TimeOfDay time) {
    selectedTime = time;
  }

  void updateSelection(val) {
    if (selectedDay.contains(val)) {
      selectedDay.remove(val);
    } else {
      selectedDay.add(val);
    }
  }

  Future<void> createRoutine() async {
    try {
      creating = true;
      notifyListeners();
      goals = ['Affirmation', ...goals];
      var map = {
        "profileId": profileId,
        "startDate": DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now().add(Duration(days: 1))),
        "durationDays": int.parse(durationDays!),
        "timeOfDay": timeOfDay?.toLowerCase(),
        "dailyDurationMinutes": int.parse(dailyDurationMinutes!),
        "goals": goals.map((g) => g.toLowerCase()).toList(),
        "hasReminder": remainder,
        if (remainder) "reminderDays": selectedDay,
        if (remainder) "reminderTime": timeOfDayTo24Hour(selectedTime!),
      };
      log(map.toString());

      await _routineData.createRoutine(map);
      showSuccessDailog();
    } catch (e) {
      rethrow;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  String timeOfDayTo24Hour(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
      'duration': '30',
    },
    {
      'icon': Assets.icons.routineCalenderIcon,
      'title': 'Habit Builder',
      'subtitle': '90 Days',
      'duration': '90',
    },
    {
      'icon': Assets.icons.routineCalenderIcon,
      'title': 'Transformation',
      'subtitle': '180 Days',
      'duration': '180',
    },
    {
      'icon': Assets.icons.routineCalenderIcon,
      'title': "Day's Mastery",
      'subtitle': '365 Days',
      'duration': '365',
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
  List<Map<String, dynamic>> thirdPageData = [
    {
      'icon': Assets.icons.alarm,
      'title': 'Quick',
      'subtitle': '20-Min',
      'time': 20,
    },
    {
      'icon': Assets.icons.alarm,
      'title': 'Focused',
      'subtitle': '30-Min',
      'time': 30,
    },
    {
      'icon': Assets.icons.alarm,
      'title': 'Productive',
      'subtitle': '45-Min',
      'time': 45,
    },
    {
      'icon': Assets.icons.alarm,
      'title': "Mindful Mastery",
      'subtitle': '60-Min',
      'time': 60,
    },
  ];

  List<Map<String, String>> fourthPageData = [
    {'icon': Assets.images.meditationRoutine.path, 'title': 'Meditation'},
    {'icon': Assets.images.yogaRoutine.path, 'title': 'Yoga'},
    {'icon': Assets.images.breathRoutine.path, 'title': 'Breathing'},
    {'icon': Assets.images.storyRoutine.path, 'title': "Stories"},
    {'icon': Assets.images.miniBodyScanRoutine.path, 'title': "Mini Body Scan"},
  ];
}
