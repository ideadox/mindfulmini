import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/common/widgets/custom_dailog.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/features/routine/providers/activities_provider.dart';

import '../journal_data/journal_data.dart';

class CreateJournalProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final journalData = sl<JournalData>();
  late String profileId;

  CreateJournalProvider(this.profileId);

  String? slectedFeeling;
  bool loading = false;

  void onChangeFeeling(val) {
    slectedFeeling = val;
    notifyListeners();
  }

  /// Non-empty lines only. Backend should accept any length (including zero);
  /// padding with empty strings fails APIs that require min 1 character per item.
  static List<String> accomplishmentsPayload(String acc) {
    return acc
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// True when the user typed something real (not only spaces/newlines).
  static bool hasAtLeastOneWord(String text) => text.trim().isNotEmpty;

  Future<void> createJournal(String des, String acc, String activityId) async {
    if (slectedFeeling == null) {
      SmartDialog.showToast('Please choose how you’re feeling today.');
      return;
    }
    if (!hasAtLeastOneWord(des)) {
      SmartDialog.showToast(
        'Please write at least a word for what you’re grateful for.',
      );
      return;
    }
    if (!hasAtLeastOneWord(acc)) {
      SmartDialog.showToast(
        'Please write at least a word for what you’ll accomplish today.',
      );
      return;
    }

    try {
      loading = true;
      notifyListeners();
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd');

      var map = {
        "profileId": profileId,
        'mood': slectedFeeling,
        "date": dateFormat.format(now),
        'description': des,
        'accomplishments': accomplishmentsPayload(acc),
      };
      log(map.toString());

      await journalData.createJournal(map);

      // Update activity progress to 100% for the gratitude journal activity
      if (activityId.isNotEmpty) {
        try {
          await sl<ActivitiesProvider>().updateActivityProgress(
            activityId,
            100,
          );
        } catch (e) {
          log('Error updating gratitude activity progress: $e');
        }
      }

      showCelebrateDailog();
    } catch (e) {
      SmartDialog.showToast(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  showCelebrateDailog() {
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
          title: 'Congratulation',
          subTitle: 'A little thanks goes a long way. See you tomorrow! 😊',
          buttonText: '🎈 Celebrate & Continue',
        );
      },
    );
  }
}
