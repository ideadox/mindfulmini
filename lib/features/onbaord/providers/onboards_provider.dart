import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindfulminis/features/onbaord/screens/describe_yourself.dart';
import 'package:mindfulminis/features/onbaord/widgets/allset_dailog.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../screens/dob.dart';
import '../screens/felling_today.dart';

class OnboardsProvider with ChangeNotifier {
  final _navigation = sl<GoRouter>();
  DateTime? selectedDob;
  String? feeling;
  TextEditingController dobController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();

  onChangeDob(dob) {
    selectedDob = dob;
    dobController.text = DateFormat('MMMM d yyyy').format(selectedDob!);
    notifyListeners();
  }

  void onChangeFeeling(String feeling) {
    this.feeling = feeling;
    notifyListeners();
  }

  void onNameSave() async {
    _navigation.pushNamed(Dob.routeName);
  }

  void onDateOfBirthSave() {
    _navigation.pushNamed(FellingToday.routeName);
  }

  void onFeelingSave() {
    _navigation.pushNamed(DescribeYourself.routeName);
  }

  void onDescribeSave(String text) {
    describeController.text = text.trim();
    log(describeController.text.toString());
    showAllSetDailog();
  }

  void onSkipFeeling() {
    _navigation.pushNamed(DescribeYourself.routeName);
  }

  List<Map<String, String>> feelList = [
    {'name': 'Amazing', 'img': Assets.images.amazingFeel},
    {'name': 'So-so', 'img': Assets.images.soSoFeel},
    {'name': 'Sad', 'img': Assets.images.sadFeel},
    {'name': 'Angry', 'img': Assets.images.angryFeel},
    {'name': 'Confused', 'img': Assets.images.confused},
    {'name': 'Sleepy', 'img': Assets.images.sleepFeel},
  ];

  void showAllSetDailog() {
    SmartDialog.show(
      clickMaskDismiss: false,
      backType: SmartBackType.block,
      builder: (context) {
        return AllsetDailog(
          onCancel: () {},
          onGoToHome: () {
            sl<GoRouter>().goNamed(TabView.routeName);
          },
        );
      },
    );
  }
}
