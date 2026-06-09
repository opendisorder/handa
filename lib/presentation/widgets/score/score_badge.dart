import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Score level badge — visual indicator for the 4-tier grading system.
///
/// No red colors. Maps score level to specific gradient + icon + label.
class ScoreBadge extends StatelessWidget {
  final String scoreLevel; // 'excellent' | 'good' | 'almost' | 'try_again'
  final double? scorePercentage;
  final double size;

  const ScoreBadge({
    super.key,
    required this.scoreLevel,
    this.scorePercentage,
    this.size = ScoreBadge.defaultSize,
  });

  static const double defaultSize = 80.0;

  Gradient get _gradient {
    switch (scoreLevel) {
      case 'excellent': return AppColors.scoreExcellentGradient;
      case 'good': return AppColors.scoreGoodGradient;
      case 'almost': return AppColors.scoreAlmostGradient;
      case 'try_again': return AppColors.scoreTryAgainGradient;
      default: return AppColors.scoreAlmostGradient;
    }
  }

  IconData get _icon {
    switch (scoreLevel) {
      case 'excellent': return Icons.star_rounded;
      case 'good': return Icons.thumb_up_rounded;
      case 'almost': return Icons.trending_up_rounded;
      case 'try_again': return Icons.refresh_rounded;
      default: return Icons.help_outline;
    }
  }

  String get _label {
    switch (scoreLevel) {
      case 'excellent': return 'විශිෂ්ටයි';
      case 'good': return 'හොඳයි';
      case 'almost': return 'බොහෝ දුරට';
      case 'try_again': return 'නැවත උත්සාහ කරන්න';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLarge = size >= 80;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _gradient,
            boxShadow: [
              BoxShadow(
                color: _gradient.colors.first.withValues(alpha: 0.3),
                blurRadius: size * 0.15,
                offset: Offset(0, size * 0.08),
              ),
            ],
          ),
          child: Center(
            child: scorePercentage != null
                ? Text(
                    '${scorePercentage!.toInt()}%',
                    style: TextStyle(
                      fontSize: size * 0.3,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'NotoSansSinhala',
                    ),
                  )
                : Icon(_icon, size: size * 0.45, color: Colors.white),
          ),
        ),
        if (isLarge) ...[
          const SizedBox(height: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _gradient.colors.first,
            ),
          ),
        ],
      ],
    );
  }
}
