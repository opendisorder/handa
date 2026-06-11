import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/score/score_badge.dart';

class ResultsScreen extends ConsumerWidget {
  final double? score;
  final String? feedback;
  final String? encouragement;

  const ResultsScreen({
    super.key,
    this.score,
    this.feedback,
    this.encouragement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayScore = score ?? 85.0;
    final level = ScoreLevel.fromPercentage(displayScore);
    final phrase = encouragement ?? _encouragementFor(level);
    final fb = feedback ?? _defaultFeedback(level);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ප්‍රතිඵල'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: 48),
              ScoreBadge(percentage: displayScore, size: 160),
              const SizedBox(height: 24),
              Text(
                _levelLabel(level),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _levelColor(level),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                phrase,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (fb.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    child: Text(
                      fb,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.home),
                      icon: const Icon(Icons.home_rounded, size: 24),
                      label: const Text('නිවසට'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.replay_rounded, size: 24),
                      label: const Text('නැවත'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _levelLabel(ScoreLevel level) {
    switch (level) {
      case ScoreLevel.excellent:
        return 'විශිෂ්ටයි!';
      case ScoreLevel.good:
        return 'හොඳයි!';
      case ScoreLevel.almost:
        return 'බොහෝ දුරට හරි!';
      case ScoreLevel.tryAgain:
        return 'නැවත උත්සාහ කරන්න';
    }
  }

  Color _levelColor(ScoreLevel level) {
    switch (level) {
      case ScoreLevel.excellent:
        return AppColors.scoreExcellent;
      case ScoreLevel.good:
        return AppColors.scoreGood;
      case ScoreLevel.almost:
        return AppColors.scoreAlmost;
      case ScoreLevel.tryAgain:
        return AppColors.scoreTryAgain;
    }
  }

  String _defaultFeedback(ScoreLevel level) {
    switch (level) {
      case ScoreLevel.excellent:
        return 'ඔබේ උච්චාරණය ඉතා පැහැදිලියි!';
      case ScoreLevel.good:
        return 'හොඳ උත්සාහයක්! දිගටම පුරුදු කරන්න.';
      case ScoreLevel.almost:
        return 'තව ටිකක් පුරුදු කරන්න. ඔබට පුළුවන්!';
      case ScoreLevel.tryAgain:
        return 'කරදරයක් නෑ. විවේකීව නැවත උත්සාහ කරන්න.';
    }
  }

  String _encouragementFor(ScoreLevel level) {
    switch (level) {
      case ScoreLevel.excellent:
        return 'විශිෂ්ටයි! ඔබට පුදුමාකාර කුසලතා තියෙනවා!';
      case ScoreLevel.good:
        return 'හොඳයි! ඔබ හොඳින් ඉගෙන ගන්නවා!';
      case ScoreLevel.almost:
        return 'බොහෝ දුරට හරි! තව ටිකක් උත්සාහ කරමු!';
      case ScoreLevel.tryAgain:
        return 'කරදරයක් නෑ, නැවත උත්සාහ කරමු!';
    }
  }
}
