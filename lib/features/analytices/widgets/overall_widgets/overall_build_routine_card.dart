import 'package:flutter/material.dart';
import 'package:mindfulminis/features/analytices/widgets/overall_widgets/routine_info_card.dart';

import '../../../../gen/assets.gen.dart';
import '../../models/routine_level_model.dart';

class OverallBuildRoutineCard extends StatelessWidget {
  const OverallBuildRoutineCard({super.key});

  @override
  Widget build(BuildContext context) {
    List<RoutineLevelModel> _levelData = [
      RoutineLevelModel(
        icon: Assets.images.gratitueAvatar.path,
        subtitle: 'Gratitude Journal',
        title: '8',
        isCompleted: true,
      ),
      RoutineLevelModel(
        icon: Assets.images.affirmationAvatar.path,
        subtitle: 'Affirmation',
        title: '10',
        isCompleted: true,
      ),
      RoutineLevelModel(
        icon: Assets.images.meditationAvatar.path,
        subtitle: 'Meditation',
        title: '10',
        isCompleted: true,
      ),
      RoutineLevelModel(
        icon: Assets.images.breadthingAvatar.path,
        subtitle: 'Breath',
        title: '8',
        isCompleted: true,
      ),
    ];
    return GridView.builder(
      itemCount: _levelData.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        final item = _levelData[index];
        return RoutineInfoCard(
          icon: item.icon,
          title: item.title,
          subtitle: item.subtitle,
          isCompleted: item.isCompleted,
        );
      },
    );
  }
}
