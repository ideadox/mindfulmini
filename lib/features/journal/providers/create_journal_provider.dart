import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/journal/widgets/celebrate_dailog.dart';
import 'package:mindfulminis/injection/injection.dart';

class CreateJournalProvider with ChangeNotifier {
  final _navigationService = sl<GoRouter>();

  String? slectedFeeling;

  void onChangeFeeling(val) {
    slectedFeeling = val;
    notifyListeners();
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
        return CelebrateDailog(
          onNext: () {
            SmartDialog.dismiss();
            _navigationService.pop();
          },
        );
      },
    );
  }
}
