import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/common/widgets/custom_dailog.dart';
import 'package:mindfulminis/injection/injection.dart';

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

  Future<void> createJournal(String des, String acc, String activityId) async {
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
        'accomplishments': acc.split('\n'),
      };
      log(map.toString());

      await journalData.createJournal(map);
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
