import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/common/data/discover_data.dart';
import 'package:mindfulminis/common/widgets/custom_level_percent_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/features/journal/screens/create_journal_screen.dart';
import 'package:mindfulminis/features/mini_body_scan/screens/mini_body_scan_screen.dart';
import 'package:mindfulminis/features/play_visuals/screen/play_visuals.dart';
import 'package:mindfulminis/features/routine/providers/activities_provider.dart';
import 'package:mindfulminis/features/routine/screens/affirmation_screen.dart';
import 'package:mindfulminis/features/yoga/data/yoga_data.dart';
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
  final String? profileId;

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
    this.profileId,
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

  static const _collectionGoals = {
    'meditation': 'meditation',
    'yoga': 'yoga',
    'breathing': 'breathing',
    'story': 'stories',
    'stories': 'stories',
  };

  /// Fetches a random unwatched item from the collection and navigates
  /// directly to PlayVisuals. If all items have been viewed, loops back
  /// to the first item in the list.
  /// Returns true if the user actually played the content.
  Future<bool> _navigateToRandomContent(String collectionSlug) async {
    try {
      final discoverData = sl<DiscoverData>();
      final sections = await discoverData.getDiscoverContent(collectionSlug);

      final allItems = sections.expand((section) {
        if (section.isSingle && section.item != null) {
          return [section.item!];
        } else if (section.isSeries && section.series != null) {
          return section.series!.items;
        }
        return <dynamic>[];
      }).toList();

      if (allItems.isEmpty) return false;

      var candidates = allItems;

      if (profileId != null && profileId!.isNotEmpty) {
        final viewedIds = await discoverData.getViewedContentIds(
          collection: collectionSlug,
          profileId: profileId!,
        );
        final viewedSet = viewedIds.toSet();
        final unwatched =
            allItems.where((item) => !viewedSet.contains(item.id)).toList();
        if (unwatched.isNotEmpty) {
          candidates = unwatched;
        }
      }

      final picked = candidates[Random().nextInt(candidates.length)];

      Object? result;
      if (collectionSlug == 'yoga') {
        final yogaData = sl<YogaData>();
        final yogaContent = await yogaData.getYogaContentById(picked.id);
        result = await sl<GoRouter>().pushNamed(
          PlayVisuals.routeName,
          extra: yogaContent,
        );
      } else {
        result = await sl<GoRouter>().pushNamed(
          PlayVisuals.routeName,
          queryParameters: {
            'collection': collectionSlug,
            'id': picked.id,
          },
        );
      }
      return result == true;
    } catch (e) {
      log('Error navigating to random content for $collectionSlug: $e');
      return false;
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

    bool didPlay = false;

    final collectionSlug = _collectionGoals[goal];
    if (collectionSlug != null) {
      didPlay = await _navigateToRandomContent(collectionSlug);
    } else {
      switch (goal) {
        case 'affirmation':
          await sl<GoRouter>().pushNamed(
            AffirmationScreen.routeName,
            queryParameters: {
              if (routineId != null) 'routineId': routineId!,
              if (date != null) 'date': date!,
            },
          );
          break;
        case 'gratitude journal':
          final activitiesProvider = sl<ActivitiesProvider>();
          final activity = activitiesProvider.getActivityByGoal(goal);
          await sl<GoRouter>().pushNamed(
            CreateJournalScreen.routeName,
            pathParameters: {'activityId': activity?.id ?? ''},
          );
          break;
        case 'mini body scan':
        case 'minibodyscan':
          await sl<GoRouter>().pushNamed(MiniBodyScanScreen.routeName);
          break;
        default:
          return;
      }
    }

    // Only mark progress if the user actually played the content
    if (didPlay && routineId != null && date != null) {
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
