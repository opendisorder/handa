import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

enum BreathPhase { inhale, hold, exhale, rest }

class BreathingScreen extends ConsumerStatefulWidget {
  const BreathingScreen({super.key});

  @override
  ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends ConsumerState<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  BreathPhase _phase = BreathPhase.rest;
  int _currentCycle = 0;
  int _phaseSeconds = 0;
  Timer? _timer;
  bool _isActive = false;

  static const _inhaleSec = 4;
  static const _holdSec = 4;
  static const _exhaleSec = 6;
  static const _totalCycles = 5;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _inhaleSec + _holdSec + _exhaleSec),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _opacityAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  void _startExercise() {
    setState(() {
      _isActive = true;
      _currentCycle = 1;
    });
    _startPhase(BreathPhase.inhale);
    _animController.repeat();
  }

  void _startPhase(BreathPhase phase) {
    setState(() {
      _phase = phase;
      _phaseSeconds = 0;
    });
    HapticFeedback.lightImpact();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _phaseSeconds++);
      final maxSec = phase == BreathPhase.inhale
          ? _inhaleSec
          : phase == BreathPhase.hold
              ? _holdSec
              : _exhaleSec;
      if (_phaseSeconds >= maxSec) {
        t.cancel();
        _advancePhase();
      }
    });
  }

  void _advancePhase() {
    if (!mounted) return;
    switch (_phase) {
      case BreathPhase.inhale:
        _startPhase(BreathPhase.hold);
      case BreathPhase.hold:
        _startPhase(BreathPhase.exhale);
      case BreathPhase.exhale:
        if (_currentCycle >= _totalCycles) {
          _finishExercise();
        } else {
          setState(() => _currentCycle++);
          _startPhase(BreathPhase.inhale);
        }
      case BreathPhase.rest:
        _startPhase(BreathPhase.inhale);
    }
  }

  void _finishExercise() {
    _timer?.cancel();
    _animController.stop();
    setState(() => _isActive = false);
    HapticFeedback.heavyImpact();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppConstants.breathCyclesPerSession >= 5
                ? 'විශිෂ්ටයි! හුස්ම අභ්‍යාස සම්පූර්ණයි!'
                : 'හොඳයි! හුස්ම අභ්‍යාස අවසන්!',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  String get _phaseLabel {
    switch (_phase) {
      case BreathPhase.inhale:
        return 'හුස්ම ඇතුලට ගන්න';
      case BreathPhase.hold:
        return 'හුස්ම රඳවන්න';
      case BreathPhase.exhale:
        return 'හුස්ම පිට කරන්න';
      case BreathPhase.rest:
        return 'සූදානම් වන්න';
    }
  }

  Color get _phaseColor {
    switch (_phase) {
      case BreathPhase.inhale:
        return AppColors.inhale;
      case BreathPhase.hold:
        return AppColors.hold;
      case BreathPhase.exhale:
        return AppColors.exhale;
      case BreathPhase.rest:
        return AppColors.primaryLight;
    }
  }

  Duration get _phaseDuration {
    switch (_phase) {
      case BreathPhase.inhale:
        return const Duration(seconds: _inhaleSec);
      case BreathPhase.hold:
        return const Duration(seconds: _holdSec);
      case BreathPhase.exhale:
        return const Duration(seconds: _exhaleSec);
      case BreathPhase.rest:
        return Duration.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('හුස්ම අභ්‍යාස'),
        actions: [
          if (!_isActive)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showInfoDialog(),
              tooltip: 'තොරතුරු',
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isActive) ..._buildIdleContent(),
              if (_isActive) ..._buildActiveContent(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIdleContent() {
    return [
      Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.air_rounded, size: 80, color: Colors.white),
      ),
      const SizedBox(height: 48),
      Text(
        'හුස්ම ගැනීමේ අභ්‍යාස',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      Text(
        'තත්පර $_inhaleSec - $_holdSec - $_exhaleSec \nචක්‍ර $_totalCycles ක්',
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 48),
      FilledButton.icon(
        onPressed: _startExercise,
        icon: const Icon(Icons.play_arrow_rounded, size: 36),
        label: const Text('ආරම්භ කරන්න'),
      ),
    ];
  }

  List<Widget> _buildActiveContent() {
    final progress = _currentCycle / _totalCycles;
    return [
      Text(
        'චක්‍රය $_currentCycle / $_totalCycles',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 32),
      AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final scale = _phase == BreathPhase.inhale
              ? _scaleAnim.value
              : _phase == BreathPhase.exhale
                  ? 1.0 - (_scaleAnim.value - 0.6)
                  : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _phaseColor.withValues(alpha: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: _phaseColor.withValues(alpha: 0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${_phaseSeconds + 1}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 32),
      Text(
        _phaseLabel,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: _phaseColor,
        ),
      ),
      const SizedBox(height: 48),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.divider,
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
          minHeight: 8,
        ),
      ),
      const SizedBox(height: 16),
      TextButton(
        onPressed: _finishExercise,
        child: const Text('නවත්වන්න'),
      ),
    ];
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('හුස්ම අභ්‍යාස උපදෙස්'),
            content: Text(
              '1. සුවපහසු ලෙස වාඩි වන්න\n'
              '2. $_inhaleSec තත්පර: හුස්ම ඇතුලට ගන්න\n'
              '3. $_holdSec තත්පර: හුස්ම රඳවන්න\n'
              '4. $_exhaleSec තත්පර: හුස්ම පිට කරන්න\n'
              '5. $_totalCycles වතාවක් පුනරුච්චාරණය කරන්න\n\n'
              'මෙය මාසයක් සඳහා දිනපතා කරන්න.\n'
              'කතා කිරීමට පෙර මෙය කිරීම ප්‍රයෝජනවත්.',
              style: Theme.of(ctx).textTheme.bodyLarge,
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('හරි'),
              ),
            ],
          ),
    );
  }
}
