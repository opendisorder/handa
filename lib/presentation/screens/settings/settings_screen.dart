import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

final _languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.sinhala);
final _ttsSpeedProvider = StateProvider<double>((ref) => 0.8);
final _hapticEnabledProvider = StateProvider<bool>((ref) => true);
final _pinProvider = StateProvider<String>((ref) => '');
final _pinAttemptsProvider = StateProvider<int>((ref) => 0);
final _isLockedProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showDashboard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('සැකසුම්')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          children: [
            _buildLanguageSection(),
            const SizedBox(height: AppConstants.spacingMd),
            _buildSpeechSection(),
            const SizedBox(height: AppConstants.spacingMd),
            _buildCaregiverSection(),
            const SizedBox(height: AppConstants.spacingMd),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection() {
    final currentLang = ref.watch(_languageProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text('භාෂාව', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            ...AppLanguage.values.map((lang) {
              final isSelected = currentLang == lang;
              return RadioListTile<AppLanguage>(
                title: Text(lang.displayName),
                value: lang,
                groupValue: currentLang,
                onChanged: (v) {
                  if (v != null) ref.read(_languageProvider.notifier).state = v;
                },
                activeColor: AppColors.primary,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechSection() {
    final speed = ref.watch(_ttsSpeedProvider);
    final haptic = ref.watch(_hapticEnabledProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.record_voice_over, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text('කතා සැකසුම්', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Text('කතා වේගය', style: Theme.of(context).textTheme.bodyLarge),
            Slider(
              value: speed,
              min: 0.3,
              max: 1.5,
              divisions: 12,
              label: speed.toStringAsFixed(1),
              onChanged: (v) => ref.read(_ttsSpeedProvider.notifier).state = v,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text('කම්පන', style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text(
                'ප්‍රතිචාර සඳහා කම්පන',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              value: haptic,
              onChanged: (v) => ref.read(_hapticEnabledProvider.notifier).state = v,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaregiverSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text('භාරකරු', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            if (!_showDashboard)
              _buildPinEntry()
            else
              _buildDashboardAccess(),
          ],
        ),
      ),
    );
  }

  Widget _buildPinEntry() {
    final pin = ref.watch(_pinProvider);
    final attempts = ref.watch(_pinAttemptsProvider);
    final isLocked = ref.watch(_isLockedProvider);

    if (isLocked) {
      return Column(
        children: [
          Icon(Icons.lock_outline, size: 48, color: AppColors.energy),
          const SizedBox(height: 8),
          Text(
            'විනාඩි ${AppConstants.pinLockoutMinutes}කට පසු උත්සාහ කරන්න',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          'PIN ඇතුළත් කරන්න',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: pin.length > i ? AppColors.primary : AppColors.divider,
              ),
            );
          }),
        ),
        if (attempts > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'උත්සාහ ${AppConstants.maxPinAttempts - attempts}ක් ඉතිරියි',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.energy),
            ),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(9, (i) {
            return SizedBox(
              width: 72,
              height: 72,
              child: OutlinedButton(
                onPressed: () => _onDigitPressed('${i + 1}'),
                child: Text('${i + 1}', style: const TextStyle(fontSize: 28)),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: OutlinedButton(
                onPressed: () => _onDigitPressed('0'),
                child: const Text('0', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 72,
              height: 72,
              child: OutlinedButton(
                onPressed: () {
                  if (pin.isNotEmpty) {
                    ref.read(_pinProvider.notifier).update((s) => s.substring(0, s.length - 1));
                  }
                },
                child: const Icon(Icons.backspace_outlined, size: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onDigitPressed(String digit) {
    final pin = ref.read(_pinProvider);
    if (pin.length >= 4) return;
    ref.read(_pinProvider.notifier).update((s) => s + digit);

    if (pin.length + 1 == 4) {
      final newPin = pin + digit;
      if (newPin == '1234') {
        setState(() => _showDashboard = true);
        ref.read(_pinAttemptsProvider.notifier).state = 0;
      } else {
        final attempts = ref.read(_pinAttemptsProvider.notifier);
        attempts.update((s) => s + 1);
        if (ref.read(_pinAttemptsProvider) >= AppConstants.maxPinAttempts) {
          ref.read(_isLockedProvider.notifier).state = true;
          Future.delayed(Duration(minutes: AppConstants.pinLockoutMinutes), () {
            if (mounted) {
              ref.read(_isLockedProvider.notifier).state = false;
              ref.read(_pinAttemptsProvider.notifier).state = 0;
            }
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('වැරදි PIN කේතය')),
        );
        ref.read(_pinProvider.notifier).state = '';
      }
    }
  }

  Widget _buildDashboardAccess() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 24),
            const SizedBox(width: 8),
            Text('භාරකරු තහවුරු කර ඇත', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.dashboard),
          icon: const Icon(Icons.analytics_outlined),
          label: const Text('ප්‍රගතිය බලන්න'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            setState(() => _showDashboard = false);
            ref.read(_pinProvider.notifier).state = '';
          },
          child: const Text('අගුළු දමන්න'),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text('තොරතුරු', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            _infoRow('යෙදුම', '${AppConstants.appName} (${AppConstants.appNameSinhala})'),
            _infoRow('අනුවාදය', AppConstants.version),
            _infoRow('තාක්ෂණය', 'Flutter + Gemini AI'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
