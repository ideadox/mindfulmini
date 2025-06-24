import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/features/journal/journal_data/journal_data.dart';
import 'package:mindfulminis/features/journal/models/gratiude_journal_model.dart';
import 'package:mindfulminis/features/journal/screens/create_journal_screen.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../../services/shared_prefs.dart';

class JournalProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final journal = sl<JournalData>();
  final _sharedPrefs = sl<SharedPrefs>();

  void navigateToCreateJournal() {
    _navigationService.pushNamed(CreateJournalScreen.routeName);
  }

  void navigateToJournalDetail() {
    _navigationService.pushNamed(JournalDetailScreen.routeName);
  }

  List<GratiudeJournalModel> gratitudeJournals = [];
  bool isLoading = false;
  Future<void> getGratitudeJournals() async {
    try {
      isLoading = true;
      notifyListeners();

      final now = DateTime.now();

      final firstDay = DateTime(now.year, now.month, 1);

      final lastDay = DateTime(now.year, now.month + 1, 0);

      final dateFormat = DateFormat('yyyy-MM-dd');
      var map = {
        "profileId": _sharedPrefs.getUserId(),
        "startDate": dateFormat.format(firstDay),
        "endDate": dateFormat.format(lastDay),
      };
      gratitudeJournals = await journal.getGratitudeJournals(map);
    } catch (e) {
      SmartDialog.showToast(
        'Failed to load gratitude journals',
        displayTime: const Duration(seconds: 2),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
