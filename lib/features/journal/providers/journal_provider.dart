import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/journal/screens/create_journal_screen.dart';
import 'package:mindfulminis/features/journal/screens/journal_detail_screen.dart';
import 'package:mindfulminis/injection/injection.dart';

class JournalProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();

  void navigateToCreateJournal() {
    _navigationService.pushNamed(CreateJournalScreen.routeName);
  }

  void navigateToJournalDetail() {
    _navigationService.pushNamed(JournalDetailScreen.routeName);
  }
}
