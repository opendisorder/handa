import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/models/exercise.dart';

/// Card widget displaying a single picture-naming exercise.
///
/// Shows the exercise image, target word, and current mastery status.
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final bool isMastered;
  final VoidCallback onTap;
  final double? bestScore;

  const ExerciseCard({
    super.key,
    required this.exercise,
    this.isMastered = false,
    required this.onTap,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.image_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              // Exercise info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.targetWordSi,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (exercise.phoneticHint != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        exercise.phoneticHint!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    Row(
                      children: [
                        _DifficultyIndicator(difficulty: exercise.difficulty),
                        const Spacer(),
                        if (bestScore != null)
                          Text(
                            '${bestScore!.toInt()}%',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: bestScore! >= AppConstants.goodThreshold
                                      ? AppColors.success
                                      : AppColors.energy,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Mastery check
              if (isMastered)
                const Icon(Icons.check_circle, color: AppColors.success, size: 28),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyIndicator extends StatelessWidget {
  final int difficulty;

  const _DifficultyIndicator({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        return Icon(
          Icons.circle,
          size: 10,
          color: i < difficulty ? AppColors.primary : AppColors.divider,
        );
      }),
    );
  }
}
