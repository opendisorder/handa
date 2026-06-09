import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppConstants.appNameSinhala),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
            tooltip: 'සැකසුම්',
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => context.push(AppRoutes.dashboard),
            tooltip: 'ප්‍රගතිය',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Welcome Header ──────────────────────────
              const SizedBox(height: AppConstants.spacingLg),
              Text(
                'ආයුබෝවන්!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'අද අපි පුහුණු වෙමු',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.spacingXl),

              // ─── Main Mode Cards ─────────────────────────
              Expanded(
                child: ListView(
                  children: [
                    _ModeCard(
                      icon: Icons.image_search_rounded,
                      title: 'පින්තූර නම් කරන්න',
                      subtitle: 'Picture Naming',
                      description: 'පින්තූර බලා නම කියන්න',
                      gradient: AppColors.primaryGradient,
                      onTap: () => context.push(AppRoutes.exercise),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _ModeCard(
                      icon: Icons.chat_rounded,
                      title: 'කතා කරමු',
                      subtitle: 'Live Conversation',
                      description: 'සැහැල්ලු සංවාද පුහුණුව',
                      gradient: LinearGradient(
                        colors: [AppColors.energy, AppColors.softPeach],
                      ),
                      onTap: () => context.push(AppRoutes.conversation),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _ModeCard(
                      icon: Icons.air_rounded,
                      title: 'හුස්ම ගන්න',
                      subtitle: 'Breathing Exercise',
                      description: 'සන්සුන් වීමට හුස්ම අභ්‍යාස',
                      gradient: LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.accent],
                      ),
                      onTap: () => context.push(AppRoutes.breathing),
                    ),
                  ],
                ),
              ),

              // ─── Continue Session Button ──────────────────
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacingMd,
                    bottom: AppConstants.spacingSm,
                  ),
                  child: FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.session),
                    icon: const Icon(Icons.play_arrow_rounded, size: 32),
                    label: const Text('අභ්‍යාස ආරම්භ කරන්න'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            gradient: gradient,
          ),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Icon(icon, size: 36, color: Colors.white),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 36,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
