import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import 'package:mindfulminis/features/journal/journal_data/journal_data.dart';
import 'package:mindfulminis/features/journal/models/gratiude_journal_model.dart';
import 'package:mindfulminis/features/journal/screens/create_journal_screen.dart';
import 'package:mindfulminis/injection/injection.dart';

class JournalProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();
  final journal = sl<JournalData>();

  late String profileId;

  JournalProvider(this.profileId);

  void navigateToCreateJournal() async {
    await _navigationService.pushNamed(
      CreateJournalScreen.routeName,
      pathParameters: {'activityId': 'rvr'},
    );
    await getGratitudeJournals();
  }

  List<GratiudeJournalModel> gratitudeJournals = [];
  bool isLoading = false;
  Future<void> getGratitudeJournals() async {
    try {
      isLoading = true;
      notifyListeners();
      final now = DateTime.now();
      gratitudeJournals = await journal.getGratitudeJournals(
        profileId,
        now.year.toString(),
        now.month.toString(),
      );
    } catch (e) {
      SmartDialog.showToast(
        e.toString(),
        displayTime: const Duration(seconds: 2),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
