import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/custom_level_percent_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/journal/screens/create_journal_screen.dart';
import 'package:mindfulminis/features/routine/models/activity_content_model.dart';
import 'package:mindfulminis/features/routine/screens/affirmation_screen.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/injection/injection.dart';

class RoutineLevelContainer extends StatelessWidget {
  final int index;
  final bool isCompleted;
  final bool currentLevel;
  final ActivityContentModel activityContentModel;
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
        if (activityContentModel.goal == 'Gratitude Journal') {
          sl<GoRouter>().pushNamed(
            CreateJournalScreen.routeName,
            pathParameters: {'activityId': activityContentModel.id},
          );
        } else if (activityContentModel.goal == 'Affirmation') {
          sl<GoRouter>().pushNamed(AffirmationScreen.routeName);
        } else if (activityContentModel.goal == 'Meditation') {
          // Navigate to Meditation screen
        } else if (activityContentModel.goal == 'Yoga') {
          // Navigate to Yoga screen
        } else if (activityContentModel.goal == 'Breathing') {
          // Navigate to Breathing screen
        } else if (activityContentModel.goal == 'Stories') {
          // Navigate to Stories screen
        } else if (activityContentModel.goal == 'Mini body scan') {
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
              activityContentModel.goal,
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
              percent: activityContentModel.progressStatus.toDouble() / 100,
            ),
          ),
        ),
      ),
    );
  }
}
