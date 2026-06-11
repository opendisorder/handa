import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/database_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _nameController = TextEditingController();
  String _selectedGender = '';
  final _ageController = TextEditingController();

  bool get _canContinue {
    switch (_currentPage) {
      case 0: return true;
      case 1: return _nameController.text.trim().length >= 2;
      case 2: return _selectedGender.isNotEmpty && _ageController.text.trim().isNotEmpty;
      case 3: return true;
      default: return false;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final settings = ref.read(settingsRepositoryProvider);
    await settings.setString('user_name', _nameController.text.trim());
    await settings.setString('user_gender', _selectedGender);
    await settings.setString('user_age', _ageController.text.trim());
    await settings.setString('first_run_complete', 'true');
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (_currentPage < 3)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('මඟ හරින්න'),
                ),
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcome(),
                  _buildNameInput(),
                  _buildGenderAge(),
                  _buildDone(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _currentPage > 0
                          ? TextButton(
                              onPressed: () => _pageController.previousPage(
                                duration: AppConstants.animNormal,
                                curve: Curves.easeInOut,
                              ),
                              child: const Text('ආපසු'),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (i) => Container(
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == i ? AppColors.primary : AppColors.divider,
                      ),
                    )),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: _canContinue
                            ? () {
                                if (_currentPage == 3) {
                                  _finishOnboarding();
                                } else {
                                  _pageController.nextPage(
                                    duration: AppConstants.animNormal,
                                    curve: Curves.easeInOut,
                                  );
                                }
                              }
                            : null,
                        child: Text(_currentPage == 3 ? 'ආරම්භ කරන්න' : 'ඉදිරියට'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20, offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.record_voice_over_rounded, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text(
            'හඩ වෙත සාදරයෙන් පිළිගනිමු!',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'ආඝාතයෙන් පසු කථන පුනරුත්ථාපනය සඳහා ඔබේ පුද්ගලික සහායකයා',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            'Find your voice again',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary, fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ඔබේ නම කුමක්ද?',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'What is your name?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: const InputDecoration(
              hintText: 'ඔබේ නම ඇතුළත් කරන්න',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderAge() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ඔබ ගැන තව ටිකක්',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _genderChip('පිරිමි', Icons.male),
              const SizedBox(width: 16),
              _genderChip('ගැහැණු', Icons.female),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 120,
            child: TextField(
              controller: _ageController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: const InputDecoration(
                labelText: 'වයස',
                hintText: '30',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderChip(String label, IconData icon) {
    final selected = _selectedGender == label;
    return FilterChip(
      selected: selected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      onSelected: (v) => setState(() => _selectedGender = v ? label : ''),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildDone() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.check_circle_rounded, size: 60, color: AppColors.success),
          ),
          const SizedBox(height: 24),
          Text(
            'සියල්ල සූදානම්!',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'ඔබේ පුනරුත්ථාපන ගමන ආරම්භ කරමු',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
