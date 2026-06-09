import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/exercise/exercise_screen.dart';
import '../screens/session/session_screen.dart';
import '../screens/results/results_screen.dart';
import '../screens/conversation/conversation_screen.dart';
import '../screens/breathing/breathing_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Route path constants
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const home = '/home';
  static const exercise = '/exercise';
  static const session = '/session';
  static const results = '/results';
  static const conversation = '/conversation';
  static const breathing = '/breathing';
  static const dashboard = '/dashboard';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.exercise,
        name: 'exercise',
        builder: (context, state) => const ExerciseScreen(),
      ),
      GoRoute(
        path: AppRoutes.session,
        name: 'session',
        builder: (context, state) => const SessionScreen(),
      ),
      GoRoute(
        path: AppRoutes.results,
        name: 'results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: AppRoutes.conversation,
        name: 'conversation',
        builder: (context, state) => const ConversationScreen(),
      ),
      GoRoute(
        path: AppRoutes.breathing,
        name: 'breathing',
        builder: (context, state) => const BreathingScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    errorBuilder:
        (context, state) => Scaffold(
          backgroundColor: const Color(0xFFFDF6EC),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFF4A261),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'පිටුව හමු නොවීය',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Page not found',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('ගෙදර යන්න'),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
});
