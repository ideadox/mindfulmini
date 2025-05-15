import 'package:flutter/material.dart';
import 'package:mindfulminis/common/widgets/custom_level_percent_indicator.dart';
import 'package:mindfulminis/core/app_colors.dart';
import 'package:mindfulminis/gen/assets.gen.dart';

class RoutineLevelContainer extends StatelessWidget {
  final bool isCompleted;
  final bool currentLevel;
  const RoutineLevelContainer({
    super.key,
    this.isCompleted = false,
    this.currentLevel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            backgroundImage: AssetImage(Assets.dummy.breathingExeActivity.path),
          ),
          title: Text(
            'Breath',
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
            percent:
                isCompleted
                    ? 1
                    : currentLevel
                    ? 0.3
                    : 0,
          ),
        ),
      ),
    );
  }
}
