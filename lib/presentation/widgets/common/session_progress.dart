import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Session progress bar showing completed vs total exercises.
class SessionProgressBar extends StatelessWidget {
  final int completed;
  final int total;
  final double? averageScore;

  const SessionProgressBar({
    super.key,
    required this.completed,
    required this.total,
    this.averageScore,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$completed / $total',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (averageScore != null)
              Text(
                '${averageScore!.toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 1.0 ? AppColors.success : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Streak indicator showing consecutive days of practice.
class StreakIndicator extends StatelessWidget {
  final int currentStreak;

  const StreakIndicator({super.key, required this.currentStreak});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          currentStreak > 0 ? Icons.local_fire_department : Icons.local_fire_department_outlined,
          color: currentStreak > 0 ? AppColors.energy : AppColors.textHint,
          size: 28,
        ),
        const SizedBox(width: 4),
        Text(
          currentStreak > 0 ? '$currentStreak' : '0',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: currentStreak > 0 ? AppColors.energy : AppColors.textHint,
              ),
        ),
        const SizedBox(width: 4),
        Text(
          'දින',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
