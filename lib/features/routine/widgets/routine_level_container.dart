import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/custom_level_percent_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/routine/screens/affirmation_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../models/activity_model.dart';

class RoutineLevelContainer extends StatelessWidget {
  final int index;
  final bool isCompleted;
  final bool currentLevel;
  final Goal activityContentModel;
  const RoutineLevelContainer({
    super.key,
    this.isCompleted = false,
    this.currentLevel = false,
    required this.index,
    required this.activityContentModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (activityContentModel.title == 'Gratitude Journal') {
          // sl<GoRouter>().pushNamed(
          //   CreateJournalScreen.routeName,
          //   pathParameters: {'activityId': activityContentModel.id},
          // );
        } else if (activityContentModel.title == 'affirmation') {
          sl<GoRouter>().pushNamed(AffirmationScreen.routeName);
        } else if (activityContentModel.title == 'meditation') {
          // Navigate to Meditation screen
        } else if (activityContentModel.title == 'yoga') {
          // Navigate to Yoga screen
        } else if (activityContentModel.title == 'breathing') {
          // Navigate to Breathing screen
        } else if (activityContentModel.title == 'stories') {
          // Navigate to Stories screen
        } else if (activityContentModel.title == 'mini body scan') {
          // Navigate to Mini body scan screen
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border:
              currentLevel == true
                  ? null
                  : Border.all(color: Colors.grey.shade300),
          gradient: currentLevel == false ? null : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(
                Assets.dummy.breathingExeActivity.path,
              ),
            ),
            title: Text(
              '${activityContentModel.title[0].toUpperCase()}${activityContentModel.title.substring(1)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '5 min per day',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey45,
              ),
            ),
            trailing: CustomLevelPercentIndicator(
              percent: activityContentModel.progress.toDouble() / 100,
            ),
          ),
        ),
      ),
    );
  }
}
