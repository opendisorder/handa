import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';
import 'package:gemini_live_fork/gemini_live.dart';

import '../../router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/models/exercise_content.dart';
import '../../../domain/services/cueing_ladder_service.dart';
import '../../../data/services/background_agent_orchestrator.dart';
import '../../../data/services/function_declarations.dart';
import '../../../data/services/tool_call_handler_service.dart';
import '../../providers/digital_brain_providers.dart';
import '../../providers/live_api_provider.dart';
import '../../widgets/common/live_audio_player.dart';
import '../../widgets/score/score_badge.dart';

final _exerciseCategoriesProvider = Provider<List<ExerciseCategory>>((ref) {
  return ExerciseCategory.sampleCategories();
});
final _currentCategoryProvider = StateProvider<ExerciseCategory?>((ref) => null);
final _currentExerciseIndexProvider = StateProvider<int>((ref) => 0);
final _resultsProvider = StateProvider<List<ExerciseResult>>((ref) => []);

enum _ExercisePhase {
  connecting,
  asking,
  listening,
  evaluating,
  result,
  completed,
}

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key});
  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  final LiveAudioPlayer _audioPlayer = LiveAudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Uint8List>? _audioStreamSubscription;

  _ExercisePhase _phase = _ExercisePhase.connecting;
  bool _isMicStreaming = false;
  bool _isSendingAudio = false;

  String? _lastOutputTranscription;
  String? _lastInputTranscription;
  String? _lastEvaluationText;
  bool _wasCorrect = false;
  int _audioChunksSent = 0;

  ToolCallHandlerService? _toolCallHandler;
  bool _disconnectOnEnd = false;
  final CueingLadderService _cueLadder = CueingLadderService();
  CueLevel _currentCueLevel = CueLevel.freeRecall;
  int _cueRetries = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
  }

  @override
  void dispose() {
    _audioStreamSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    // Only disconnect if end_session wasn't already called (it handles disconnect)
    if (!_disconnectOnEnd) {
      ref.read(liveApiServiceProvider).disconnect();
    }
    super.dispose();
  }

  Future<void> _startSession() async {
    final service = ref.read(liveApiServiceProvider);
    final category = ref.read(_currentCategoryProvider);
    if (category == null) return;

    // Initialize tool call handler with background agent integration
    final orchestrator = ref.read(backgroundAgentOrchestratorProvider);
    final sessionLogStore = ref.read(sessionLogStoreProvider);
    _toolCallHandler = ToolCallHandlerService(
      orchestrator: orchestrator,
      sessionLogStore: sessionLogStore,
      liveApiService: service,
      onUiAction: (name, args) {
        debugPrint('[ExerciseScreen] UI action: $name $args');
      },
    );
    _toolCallHandler!.reset();

    // Build function declarations for exercise tool calling
    final tools = [
      Tool(functionDeclarations: exerciseFunctionDeclarations()),
    ];

    await service.connect(
      systemInstruction: await _buildSystemPrompt(category),
      tools: tools,
      onMessage: _handleMessage,
      onError: (error, _) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
      },
      onState: (connected) {
        if (!connected && mounted) {
          setState(() => _phase = _ExercisePhase.completed);
        }
      },
    );
  }

  Future<String> _buildSystemPrompt(ExerciseCategory category) async {
    final digitalBrain = ref.read(digitalBrainServiceProvider);
    final memoryBlock = await digitalBrain.buildMemoryBlock();
    final memorySection = memoryBlock.isNotEmpty
        ? '\n$memoryBlock\n'
        : '';
    return '''${memorySection}You are a Sinhala speech rehabilitation therapist for stroke patients.
The user is practicing the "${category.nameSi}" (${category.name}) category.

You use a 4-level cueing ladder to help the patient:
- CUE LEVEL 0 (Free Recall): Ask "මෙය කුමක්ද?" Give NO hints.
- CUE LEVEL 1 (Phonetic): Give only the first syllable as a hint.
- CUE LEVEL 2 (Syllables): Break the word into syllables, say each slowly.
- CUE LEVEL 3 (Model): Say the full word clearly, ask patient to repeat.

The user's prompt will tell you the cue level. Follow that level's instruction.

For each exercise:
1. Greet the patient warmly.
2. Apply the specified cue level.
3. Listen to their spoken answer.
4. Rate the answer out of 100 using [score] brackets, e.g. "[85]".
5. If correct (score >= 70): say "විශිෂ්ටයි!" and repeat the word.
6. If partially close (50-69): say "බොහෝ දුරට හරි!" and say the correct word.
7. If wrong (< 50): gently say the correct word and encourage.
8. Keep responses to 1-2 short sentences in Sinhala. Speak at a clear, slightly slow pace.''';
  }

  void _handleMessage(LiveServerMessage message) {
    if (message.data != null) {
      _audioPlayer.appendBase64Chunk(message.data!);
    }

    if (message.serverContent?.outputTranscription?.text case final text?
        when text.isNotEmpty) {
      _lastOutputTranscription = text;
    }

    if (message.serverContent?.inputTranscription?.text case final text?
        when text.isNotEmpty) {
      _lastInputTranscription = text;
    }

    final turnComplete = message.serverContent?.turnComplete ?? false;
    final generationComplete =
        message.serverContent?.generationComplete ?? false;
    final finished = turnComplete || generationComplete;

    if (finished) {
      if (_phase == _ExercisePhase.asking) {
        _playAndListen();
      } else if (_phase == _ExercisePhase.evaluating) {
        _showResult();
      }
    }

    // Handle Gemini function calls (log_exercise, end_session, etc.)
    if (message.toolCall != null && _toolCallHandler != null) {
      final handler = _toolCallHandler!;
      final results = handler.handleToolCall(message.toolCall!);
      final responses = <FunctionResponse>[];

      for (final r in results) {
        responses.add(FunctionResponse(
          id: r.id,
          name: r.name,
          response: r.response,
        ));
      }

      if (responses.isNotEmpty) {
        unawaited(_sendToolResponses(responses));
      }
    }
  }

  Future<void> _sendToolResponses(List<FunctionResponse> responses) async {
    final service = ref.read(liveApiServiceProvider);
    // Send each tool response individually (LiveApiService wraps single calls)
    for (final r in responses) {
      service.sendToolResponse(
        id: r.id ?? '',
        name: r.name ?? '',
        response: r.response ?? {},
      );
    }
  }

  Future<void> _playAndListen() async {
    setState(() {
      _phase = _ExercisePhase.listening;
      _lastInputTranscription = null;
      _audioChunksSent = 0;
    });
    await _audioPlayer.playBufferedAudio();
  }

  Future<void> _showResult() async {
    await _audioPlayer.playBufferedAudio();
    if (_lastOutputTranscription != null) {
      _lastEvaluationText = _lastOutputTranscription;
      _wasCorrect =
          _lastEvaluationText!.contains('විශිෂ්ට') ||
          _lastEvaluationText!.contains('හොඳයි');
    }
    if (mounted) {
      setState(() => _phase = _ExercisePhase.result);
    }
  }

  void _askCurrentItem() {
    final category = ref.read(_currentCategoryProvider);
    final index = ref.read(_currentExerciseIndexProvider);
    if (category == null || index >= category.items.length) return;

    final item = category.items[index];
    final service = ref.read(liveApiServiceProvider);

    setState(() {
      _phase = _ExercisePhase.asking;
      _lastOutputTranscription = null;
      _lastInputTranscription = null;
      _lastEvaluationText = null;
    });

    // Include cue level instruction in the picture prompt
    final cueInstruction = _currentCueLevel.promptInstruction;
    final cueLabel = CueingLadderService.sinhalaLabel(_currentCueLevel);

    service.sendText(
      'Picture: ${item.emoji} ${item.emoji} ${item.emoji} '
      'Answer: "${item.sinhala}" (${item.english}). '
      'CUE LEVEL ${_currentCueLevel.levelIndex} ($cueLabel): $cueInstruction',
    );
  }

  void _startMicStream() async {
    if (_isMicStreaming || _phase != _ExercisePhase.listening) return;

    final hasPermission = await _audioRecorder.hasPermission();
    if (!hasPermission) return;

    setState(() => _isMicStreaming = true);

    try {
      final stream = await _audioRecorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      _audioChunksSent = 0;
      final service = ref.read(liveApiServiceProvider);

      _audioStreamSubscription = stream.listen(
        (chunk) {
          service.sendAudio(chunk);
          _audioChunksSent++;
        },
        onError: (_) => _stopMicStream(),
        cancelOnError: true,
      );
    } catch (e) {
      setState(() => _isMicStreaming = false);
    }
  }

  void _stopMicStream() {
    _audioStreamSubscription?.cancel();
    _audioStreamSubscription = null;
    _audioRecorder.stop();

    final service = ref.read(liveApiServiceProvider);
    service.sendAudioStreamEnd();

    setState(() {
      _isMicStreaming = false;
      _phase = _ExercisePhase.evaluating;
    });
  }

  void _nextExercise() {
    final index = ref.read(_currentExerciseIndexProvider);
    final category = ref.read(_currentCategoryProvider);
    if (category == null) return;

    final item = category.items[index];
    final scoreToUse = _wasCorrect ? 85.0 : 50.0;

    // If the patient got it wrong and we can still escalate the cue level...
    if (!_wasCorrect && _currentCueLevel != CueLevel.fullModel) {
      final nextLevel = _cueLadder.nextLevel(_currentCueLevel, scoreToUse);
      if (nextLevel != _currentCueLevel) {
        // Retry same item at higher cue level
        setState(() {
          _currentCueLevel = nextLevel;
          _cueRetries++;
          _phase = _ExercisePhase.connecting;
        });
        _askCurrentItem();
        return;
      }
    }

    // Save result (final attempt or correct answer)
    if (_lastEvaluationText != null) {
      ref.read(_resultsProvider.notifier).update(
        (s) => [
          ...s,
          ExerciseResult(
            item: item,
            score: scoreToUse,
            isCorrect: _wasCorrect,
            feedback: _lastEvaluationText,
          ),
        ],
      );
    }

    // Reset cue level for next item
    _currentCueLevel = CueLevel.freeRecall;
    _cueRetries = 0;

    if (index + 1 >= category.items.length) {
      ref.read(liveApiServiceProvider).disconnect();
      setState(() => _phase = _ExercisePhase.completed);
      return;
    }

    ref.read(_currentExerciseIndexProvider.notifier).update((s) => s + 1);
    _askCurrentItem();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(_exerciseCategoriesProvider);
    final currentCategory = ref.watch(_currentCategoryProvider);

    if (currentCategory == null) {
      return _buildCategoryGrid(context, categories);
    }
    return _buildExerciseView(context, currentCategory);
  }

  Widget _buildCategoryGrid(
      BuildContext context, List<ExerciseCategory> categories) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('පින්තූර නම් කරන්න')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('කාණ්ඩයක් තෝරන්න',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Choose a category',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          ref.read(_currentExerciseIndexProvider.notifier)
                              .state = 0;
                          ref.read(_resultsProvider.notifier).state = [];
                          ref.read(_currentCategoryProvider.notifier).state =
                              cat;
                        },
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMd),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusMd),
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(cat.icon,
                                  size: 48, color: Colors.white),
                              const SizedBox(height: 12),
                              Text(cat.nameSi,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: Colors.white)),
                              Text(cat.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color:
                                              Colors.white.withValues(alpha: 0.9))),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseView(BuildContext context, ExerciseCategory category) {
    final index = ref.watch(_currentExerciseIndexProvider);
    final results = ref.watch(_resultsProvider);
    final items = category.items;

    if (_phase == _ExercisePhase.completed) {
      return _buildResultsSummary(context, results, category);
    }
    if (index >= items.length) {
      return _buildResultsSummary(context, results, category);
    }

    final item = items[index];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(category.nameSi),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${index + 1}/${items.length}',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: 16),
              if (_phase == _ExercisePhase.connecting)
                _buildConnectingView()
              else ...[
                _buildImageCard(item),
                const SizedBox(height: 16),
                _buildCueLevelBadge(),
                const SizedBox(height: 8),
                _buildPhaseIndicator(),
                const SizedBox(height: 12),
                if (_lastOutputTranscription != null)
                  _buildTranscriptionBubble(_lastOutputTranscription!, false),
                if (_lastInputTranscription != null)
                  _buildTranscriptionBubble(_lastInputTranscription!, true),
                if (_phase == _ExercisePhase.result && _lastEvaluationText != null)
                  _buildResultCard(),
                const Spacer(),
                _buildActionButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectingView() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Gemini වෙත සම්බන්ධ වෙමින්...'),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(ExerciseItem item) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.divider,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(item.emoji, style: const TextStyle(fontSize: 100)),
          ),
        ),
        const SizedBox(height: 8),
        Text(item.english,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildCueLevelBadge() {
    final colors = <MaterialColor>[
      Colors.blue,
      Colors.orange,
      Colors.deepPurple,
      Colors.teal,
    ];
    final color = colors[_currentCueLevel.levelIndex];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: color.shade700),
              const SizedBox(width: 6),
              Text(
                'L${_currentCueLevel.levelIndex}: ${CueingLadderService.sinhalaLabel(_currentCueLevel)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: color.shade700,
                ),
              ),
              if (_cueRetries > 0) ...[
                const SizedBox(width: 6),
                Text(
                  '(×${_cueRetries + 1})',
                  style: TextStyle(fontSize: 12, color: color.shade400),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseIndicator() {
    String text;
    IconData icon;
    Color color;

    switch (_phase) {
      case _ExercisePhase.asking:
        text = 'අසමින්...';
        icon = Icons.volume_up;
        color = AppColors.primary;
      case _ExercisePhase.listening:
        text = 'සවන් දෙමින්...';
        icon = _isMicStreaming ? Icons.mic : Icons.mic_none;
        color = _isMicStreaming ? Colors.green : AppColors.textSecondary;
      case _ExercisePhase.evaluating:
        text = 'ඇගයීම...';
        icon = Icons.psychology;
        color = Colors.orange;
      case _ExercisePhase.result:
        text = _wasCorrect ? 'නිවැරදියි!' : 'උත්සාහ කරන්න';
        icon = _wasCorrect ? Icons.check_circle : Icons.replay;
        color = _wasCorrect ? Colors.green : Colors.orange;
      default:
        text = '';
        icon = Icons.circle;
        color = AppColors.textSecondary;
    }

    return Chip(
      avatar: Icon(icon, size: 20, color: color),
      label: Text(text, style: TextStyle(color: color)),
    );
  }

  Widget _buildTranscriptionBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isUser ? Colors.white : AppColors.textPrimary,
              ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      color: _wasCorrect ? Colors.green.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _wasCorrect ? Icons.check_circle : Icons.info,
              color: _wasCorrect ? Colors.green : Colors.orange,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _lastEvaluationText ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    switch (_phase) {
      case _ExercisePhase.asking:
      case _ExercisePhase.evaluating:
        return const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        );
      case _ExercisePhase.listening:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTapDown: (_) => _startMicStream(),
            onTapUp: (_) => _stopMicStream(),
            onTapCancel: _stopMicStream,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isMicStreaming ? Colors.red : AppColors.primary,
                boxShadow: _isMicStreaming
                    ? [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _isMicStreaming ? Icons.mic : Icons.mic_none,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        );
      case _ExercisePhase.result:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _nextExercise,
            icon: const Icon(Icons.arrow_forward, size: 28),
            label: Text(
              _isLastItem ? 'ප්‍රතිඵල බලන්න' : 'ඊළඟට',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  bool get _isLastItem {
    final category = ref.read(_currentCategoryProvider);
    final index = ref.read(_currentExerciseIndexProvider);
    return category != null && index >= category.items.length - 1;
  }

  Widget _buildResultsSummary(
    BuildContext context,
    List<ExerciseResult> results,
    ExerciseCategory category,
  ) {
    final avgScore = results.isEmpty
        ? 0.0
        : results.fold(0.0, (s, r) => s + r.score) / results.length;
    final correct = results.where((r) => r.isCorrect).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('ප්‍රතිඵල')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(category.nameSi,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              ScoreBadge(percentage: avgScore, size: 120),
              const SizedBox(height: 16),
              Text('${correct}/${results.length} නිවැරදියි',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final r = results[index];
                    return ListTile(
                      leading:
                          Text(r.item.emoji, style: const TextStyle(fontSize: 32)),
                      title: Text(r.item.sinhala),
                      subtitle: Text(r.feedback ?? ''),
                      trailing: ScoreBadge(percentage: r.score, size: 48),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(_currentCategoryProvider.notifier).state = null;
                      },
                      child: const Text('කාණ්ඩ වලට'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: const Text('නිවසට'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
