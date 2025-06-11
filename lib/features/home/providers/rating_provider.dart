import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mindfulminis/features/home/widgets/feedback/feedback_dailog.dart';

class RatingProvider with ChangeNotifier {
  int ratingCount = 0;
  String? ratingText;

  void onChnageRating(val) {
    ratingCount = val;
    notifyListeners();
  }

  showRatingDailog() {
    ratingCount = 0;
    ratingText = null;
    SmartDialog.show(
      builder: (context) {
        return FeedbackDailog();
      },
    );
  }
}
