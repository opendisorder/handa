import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ScoreBadge extends StatelessWidget {
  final String? scoreLevel;
  final double? scorePercentage;
  final double? percentage;
  final double size;

  const ScoreBadge({
    super.key,
    this.scoreLevel,
    this.scorePercentage,
    this.percentage,
    this.size = 80,
  });

  String get _effectiveLevel {
    if (scoreLevel != null) return scoreLevel!;
    final pct = scorePercentage ?? percentage;
    if (pct != null) {
      if (pct >= AppConstants.excellentThreshold) return 'excellent';
      if (pct >= AppConstants.goodThreshold) return 'good';
      if (pct >= AppConstants.almostThreshold) return 'almost';
      return 'try_again';
    }
    return 'almost';
  }

  double? get _displayPct => scorePercentage ?? percentage;

  Gradient get _gradient {
    switch (_effectiveLevel) {
      case 'excellent': return AppColors.scoreExcellentGradient;
      case 'good': return AppColors.scoreGoodGradient;
      case 'almost': return AppColors.scoreAlmostGradient;
      case 'try_again': return AppColors.scoreTryAgainGradient;
      default: return AppColors.scoreAlmostGradient;
    }
  }

  IconData get _icon {
    switch (_effectiveLevel) {
      case 'excellent': return Icons.star_rounded;
      case 'good': return Icons.thumb_up_rounded;
      case 'almost': return Icons.trending_up_rounded;
      case 'try_again': return Icons.refresh_rounded;
      default: return Icons.help_outline;
    }
  }

  String get _label {
    switch (_effectiveLevel) {
      case 'excellent': return 'විශිෂ්ටයි';
      case 'good': return 'හොඳයි';
      case 'almost': return 'බොහෝ දුරට';
      case 'try_again': return 'නැවත උත්සාහ කරන්න';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: _displayPct != null
                ? Text(
                    '${_displayPct!.toInt()}%',
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
        if (size >= 80) ...[
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
