import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/routine/models/activity_content_model.dart';
import 'package:mindfulminis/features/routine/models/activity_model.dart';

import '../../../injection/injection.dart';
import '../../../services/shared_prefs.dart';
import '../routine_data/routine_data.dart';

class RoutineActivityProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final _routineData = sl<RoutineData>();
  final _sharedPrefs = sl<SharedPrefs>();
  bool loading = false;
  bool innerLoading = false;

  RoutineActivityProvider(String id, String date) {
    getRoutineActivity(id, date);
  }

  final List<String> customOrder = [
    'Gratitude Journal',
    'Affirmation',
    'Meditation',
    'Yoga',
    'Breathing',
    'Stories',
    'Mini body scan',
  ];

  ActivityModel? activityModel;
  DateTime selectedDate = DateTime.now();

  void selectDate(date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<void> getRoutineActivity(
    String id,
    String date, {
    bool innerNotify = false,
  }) async {
    try {
      if (innerNotify) {
        innerLoading = true;
      } else {
        loading = true;
      }
      notifyListeners();
      log(date);

      activityModel = await _routineData.getRoutineActivity(id, date);
      activityModel?.activityContent.add(
        ActivityContentModel(
          id: id,
          profileId: '',
          routineId: '',
          activityId: '',
          contentId: '',
          goal: 'Gratitude Journal',
          progressStatus: 0,
          status: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          v: 0,
        ),
      );

      activityModel?.activityContent.sort(
        (a, b) =>
            customOrder.indexOf(a.goal).compareTo(customOrder.indexOf(b.goal)),
      );
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      innerLoading = false;
      notifyListeners();
    }
  }

  bool updating = false;

  Future<void> updateActivityContentProgress(String id, int progress) async {
    try {
      updating = true;
      notifyListeners();
      await _routineData.updateRoutineActivityPercent(id, progress);
    } catch (e) {
      rethrow;
    } finally {
      updating = false;
      notifyListeners();
    }
  }

  // Future<void> createJournal(String des, String acc) async {
  //   try {
  //     var map = {
  //       "profileId": _sharedPrefs.getUserId(),
  //       "activityId": "<objectId>",
  //       "emotion": slectedFeeling?.trim(),
  //       "emotionDescription": des.trim(),
  //       "accomplishments": acc.trim(),
  //       "date": "2025-06-24",
  //     };
  //     log(map.toString());
  //     // return;
  //     await _routineData.createJournal(map);
  //     // showCelebrateDailog();
  //   } catch (e) {
  //     SmartDialog.showToast('Something went wrong. Please try again later.');
  //   }
  // }
}
