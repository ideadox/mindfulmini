import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/widgets/custom_level_percent_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/breathing/screens/breathing_screen.dart';
import 'package:mindfulminis/features/journal/screens/create_journal_screen.dart';
import 'package:mindfulminis/features/meditation/screens/meditation_screen.dart';
import 'package:mindfulminis/features/routine/providers/activities_provider.dart';
import 'package:mindfulminis/features/routine/screens/affirmation_screen.dart';
import 'package:mindfulminis/features/stories/screens/stories_screen.dart';
import 'package:mindfulminis/features/yoga/screens/yoga_main.dart';
import 'package:mindfulminis/gen/assets.gen.dart';
import 'package:mindfulminis/core/injection/injection.dart';

import '../models/activity_model.dart';

class RoutineLevelContainer extends StatelessWidget {
  final int index;
  final bool isCompleted;
  final bool currentLevel;
  final Goal activityContentModel;
  final String? routineId;
  final String? date;
  final int? dailyDurationMinutes;

  /// Called after the user returns from an activity screen so the parent
  /// can re-fetch progress data.
  final VoidCallback? onReturn;

  const RoutineLevelContainer({
    super.key,
    this.isCompleted = false,
    this.currentLevel = false,
    required this.index,
    required this.activityContentModel,
    this.routineId,
    this.date,
    this.dailyDurationMinutes,
    this.onReturn,
  });

  /// Returns a goal-appropriate icon asset path
  String _getGoalIcon(String goal) {
    switch (goal.toLowerCase()) {
      case 'affirmation':
        return Assets.images.meditationRoutine.path;
      case 'meditation':
        return Assets.images.meditationRoutine.path;
      case 'yoga':
        return Assets.images.yogaRoutine.path;
      case 'breathing':
        return Assets.images.breathRoutine.path;
      case 'story':
      case 'stories':
        return Assets.images.storyRoutine.path;
      case 'mini body scan':
      case 'minibodyscan':
        return Assets.images.miniBodyScanRoutine.path;
      default:
        return Assets.images.meditationRoutine.path;
    }
  }

  /// Navigate to the appropriate screen based on goal type.
  /// Awaits the push so we can refresh data when the user returns.
  Future<void> _onTap() async {
    final goal = activityContentModel.title.toLowerCase();

    // Pre-load activities so we can track progress by activityId
    if (routineId != null && date != null) {
      final activitiesProvider = sl<ActivitiesProvider>();
      if (activitiesProvider.activities.isEmpty) {
        await activitiesProvider.getActivities(routineId!, date!);
      }
    }

    switch (goal) {
      case 'affirmation':
        // Affirmation handles its own progress internally
        await sl<GoRouter>().pushNamed(
          AffirmationScreen.routeName,
          queryParameters: {
            if (routineId != null) 'routineId': routineId!,
            if (date != null) 'date': date!,
          },
        );
        break;
      case 'meditation':
        await sl<GoRouter>().pushNamed(MeditationScreen.routeName);
        break;
      case 'yoga':
        await sl<GoRouter>().pushNamed(YogaMain.routeName);
        break;
      case 'breathing':
        await sl<GoRouter>().pushNamed(BreathingScreen.routeName);
        break;
      case 'story':
      case 'stories':
        await sl<GoRouter>().pushNamed(StoriesScreen.routeName);
        break;
      case 'gratitude journal':
        // Get the activity ID for progress tracking
        final activitiesProvider = sl<ActivitiesProvider>();
        final activity = activitiesProvider.getActivityByGoal(goal);
        await sl<GoRouter>().pushNamed(
          CreateJournalScreen.routeName,
          pathParameters: {'activityId': activity?.id ?? ''},
        );
        break;
      case 'mini body scan':
      case 'minibodyscan':
        // TODO: Navigate to Mini Body Scan screen when available
        break;
      default:
        return; // no navigation happened, skip onReturn
    }

    // Update progress for activities that complete on return
    // (Affirmation handles its own; gratitude is handled on journal submit)
    if (routineId != null && date != null) {
      if (goal != 'affirmation' && goal != 'gratitude journal') {
        try {
          final activitiesProvider = sl<ActivitiesProvider>();
          final activity = activitiesProvider.getActivityByGoal(goal);
          if (activity != null && activity.progressStatus < 100) {
            await activitiesProvider.updateActivityProgress(activity.id, 100);
          }
        } catch (e) {
          log('Error updating activity progress for $goal: $e');
        }
      }
    }

    // Re-fetch progress data now that the user has returned
    onReturn?.call();
  }

  @override
  Widget build(BuildContext context) {
    final goalTitle = activityContentModel.title;
    final displayTitle =
        '${goalTitle[0].toUpperCase()}${goalTitle.substring(1)}';

    // Calculate per-goal minutes from total daily minutes and number of goals
    // Fallback to a reasonable default
    final minutesPerDay = dailyDurationMinutes ?? 5;

    return InkWell(
      onTap: _onTap,
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
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(_getGoalIcon(goalTitle)),
            ),
            title: Text(
              displayTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '$minutesPerDay min per day',
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
