import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

/// Full-screen loading indicator with Sinhala message.
class AppLoadingIndicator extends StatelessWidget {
  final String message;
  final String? subtitle;

  const AppLoadingIndicator({
    super.key,
    this.message = 'පූරණය වෙමින්...',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 4,
            ),
            const SizedBox(height: 24),
            Text(message, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

/// Three-state UI helper: loading / error / data.
class AsyncWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final String? loadingMessage;
  final String? errorMessage;

  const AsyncWidget({
    super.key,
    required this.value,
    required this.data,
    this.loadingMessage,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => AppLoadingIndicator(message: loadingMessage ?? 'පූරණය වෙමින්...'),
      error: (err, stack) => AppErrorDisplay(
        message: errorMessage ?? 'දෝෂයකි. නැවත උත්සාහ කරන්න',
        onRetry: () {},
      ),
      data: data,
    );
  }
}

/// Error display widget with optional retry.
class AppErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('නැවත උත්සාහ කරන්න'),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
