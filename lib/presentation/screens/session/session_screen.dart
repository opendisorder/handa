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
import '../../../data/services/background_agent_orchestrator.dart';
import '../../../data/services/function_declarations.dart';
import '../../../data/services/tool_call_handler_service.dart';
import '../../../domain/models/exercise_content.dart';
import '../../../domain/services/cueing_ladder_service.dart';
import '../../../domain/services/scoring_engine.dart';
import '../../../domain/services/struggle_detection_service.dart';
import '../../widgets/common/session_progress.dart';
import '../../widgets/common/live_audio_player.dart';
import '../../widgets/score/score_badge.dart';
import '../../providers/database_provider.dart';
import '../../providers/digital_brain_providers.dart';
import '../../providers/live_api_provider.dart';

final _sessionStepProvider = StateProvider<int>((ref) => 0);
final _sessionResultsProvider = StateProvider<List<ExerciseResult>>((ref) => []);
final _sessionExercisesProvider = Provider<List<ExerciseItem>>((ref) {
  final categories = ExerciseCategory.sampleCategories();
  final items = <ExerciseItem>[];
  for (final cat in categories) {
    items.addAll(cat.items);
  }
  items.shuffle();
  return items.take(8).toList();
});
final _sessionIdProvider = StateProvider<int?>((ref) => null);

enum _SessionPhase {
  connecting,
  asking,
  listening,
  evaluating,
  result,
  completed,
}

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});
  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  final LiveAudioPlayer _audioPlayer = LiveAudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Uint8List>? _audioStreamSubscription;

  _SessionPhase _phase = _SessionPhase.connecting;
  bool _isMicStreaming = false;
  bool _isSaving = false;

  String? _lastOutputTranscription;
  String? _lastInputTranscription;
  String? _lastEvaluationText;
  bool _wasCorrect = false;
  double _lastScore = 0;
  int _audioChunksSent = 0;

  ToolCallHandlerService? _toolCallHandler;
  bool _disconnectOnEnd = false;
  final CueingLadderService _cueLadder = CueingLadderService();
  final StruggleDetectionService _struggleDetector = StruggleDetectionService();
  CueLevel _currentCueLevel = CueLevel.freeRecall;
  int _cueRetries = 0;
  StruggleLevel _lastStruggleLevel = StruggleLevel.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _createSession();
      _startSession();
    });
  }

  @override
  void dispose() {
    _audioStreamSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    if (!_disconnectOnEnd) {
      ref.read(liveApiServiceProvider).disconnect();
    }
    super.dispose();
  }

  Future<void> _createSession() async {
    final repo = ref.read(sessionRepositoryProvider);
    final id = await repo.createSession(
      type: 'picture_naming',
      totalExercises: ref.read(_sessionExercisesProvider).length,
    );
    ref.read(_sessionIdProvider.notifier).state = id;
  }

  Future<void> _startSession() async {
    final service = ref.read(liveApiServiceProvider);

    // Initialize tool call handler with background agent integration
    final orchestrator = ref.read(backgroundAgentOrchestratorProvider);
    final sessionLogStore = ref.read(sessionLogStoreProvider);
    _toolCallHandler = ToolCallHandlerService(
      orchestrator: orchestrator,
      sessionLogStore: sessionLogStore,
      liveApiService: service,
      onUiAction: (name, args) {
        debugPrint('[SessionScreen] UI action: $name $args');
      },
    );
    _toolCallHandler!.reset();

    final tools = [
      Tool(functionDeclarations: exerciseFunctionDeclarations()),
    ];

    await service.connect(
      systemInstruction: await _buildSystemPrompt(),
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
        if (!connected && mounted && _phase != _SessionPhase.completed) {
          setState(() => _phase = _SessionPhase.completed);
        }
      },
    );

    if (mounted) {
      _askCurrentItem();
    }
  }

  Future<String> _buildSystemPrompt() async {
    final digitalBrain = ref.read(digitalBrainServiceProvider);
    final memoryBlock = await digitalBrain.buildMemoryBlock();
    final memorySection = memoryBlock.isNotEmpty
        ? '\n$memoryBlock\n'
        : '';
    return '''${memorySection}You are a Sinhala speech rehabilitation therapist for stroke patients.
The user is practicing picture naming as part of a therapy session.

You use a 4-level cueing ladder to help the patient:
- CUE LEVEL 0 (Free Recall): Ask "මෙය කුමක්ද?" Give NO hints.
- CUE LEVEL 1 (Phonetic): Give only the first syllable as a hint.
- CUE LEVEL 2 (Syllables): Break the word into syllables, say each slowly.
- CUE LEVEL 3 (Model): Say the full word clearly, ask patient to repeat.

The prompt for each exercise includes a cue level. Follow that level's instruction.

For each exercise:
1. Greet the patient warmly and apply the specified cue level.
2. Listen to their spoken answer.
3. Rate the answer out of 100 using [score] brackets, e.g. "[85]".
4. If correct (score >= 70): say "විශිෂ්ටයි!" and repeat the word.
5. If partially close (50-69): say "බොහෝ දුරට හරි!" and say the correct word.
6. If wrong (< 50): gently say the correct word and encourage.
7. Keep responses to 1-2 short sentences in Sinhala. Speak at a clear, slow pace.''';
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
      if (_phase == _SessionPhase.asking) {
        _onModelFinishedAsking();
      } else if (_phase == _SessionPhase.evaluating) {
        _onEvaluationComplete();
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
    for (final r in responses) {
      service.sendToolResponse(
        id: r.id ?? '',
        name: r.name ?? '',
        response: r.response ?? {},
      );
    }
  }

  Future<void> _onModelFinishedAsking() async {
    setState(() {
      _phase = _SessionPhase.listening;
      _lastInputTranscription = null;
      _audioChunksSent = 0;
    });
    await _audioPlayer.playBufferedAudio();
  }

  Future<void> _onEvaluationComplete() async {
    await _audioPlayer.playBufferedAudio();

    if (_lastOutputTranscription != null) {
      _lastEvaluationText = _lastOutputTranscription;

      // 1. Try to extract explicit Gemini score from [NN] pattern
      double? geminiScore;
      final scoreMatch = RegExp(r'\[(\d+)\]').firstMatch(_lastOutputTranscription!);
      if (scoreMatch != null) {
        geminiScore = double.parse(scoreMatch.group(1)!);
      }

      // 2. Get the current exercise item for offline fallback comparison
      final exercises = ref.read(_sessionExercisesProvider);
      final step = ref.read(_sessionStepProvider);
      final item = exercises[step];

      // 3. Score via ScoringEngine: online (geminiScore) or offline (Levenshtein)
      final scoreResult = ScoringEngine.evaluate(
        userResponse: _lastInputTranscription ?? '',
        expectedAnswer: item.sinhala,
        geminiScore: geminiScore,
      );

      _lastScore = scoreResult.scorePercentage;
      _wasCorrect = _lastScore >= AppConstants.almostThreshold;

      // 4. Detect struggle level from behavioral signals
      _lastStruggleLevel = _struggleDetector.detect(
        responseTimeMs: scoreResult.responseTimeMs ?? 0,
        transcribedSpeech: _lastInputTranscription ?? '',
        expectedAnswer: item.sinhala,
        cueLevelUsed: _currentCueLevel.levelIndex,
      );

      await _saveAttempt();
    }

    if (mounted) {
      setState(() => _phase = _SessionPhase.result);
    }
  }

  Future<void> _saveAttempt() async {
    final sessionId = ref.read(_sessionIdProvider);
    final step = ref.read(_sessionStepProvider);
    final exercises = ref.read(_sessionExercisesProvider);
    if (sessionId == null || step >= exercises.length) return;

    final item = exercises[step];
    final repo = ref.read(sessionRepositoryProvider);

    // Determine score level via ScoringEngine (uses AppConstants thresholds)
    final scoreResult = ScoringEngine.evaluate(
      userResponse: _lastInputTranscription ?? '',
      expectedAnswer: item.sinhala,
      geminiScore: _lastScore,
    );

    await repo.saveAttempt(
      sessionId: sessionId,
      exerciseId: step + 1,
      userResponse: _lastInputTranscription ?? '',
      expectedAnswer: item.sinhala,
      scorePercentage: _lastScore,
      scoreLevel: scoreResult.levelString,
    );

    ref.read(_sessionResultsProvider.notifier).update(
      (s) => [
        ...s,
        ExerciseResult(
          item: item,
          score: _lastScore,
          isCorrect: _wasCorrect,
          feedback: _lastEvaluationText,
        ),
      ],
    );
  }

  void _askCurrentItem() {
    final step = ref.read(_sessionStepProvider);
    final exercises = ref.read(_sessionExercisesProvider);
    if (step >= exercises.length) return;

    final item = exercises[step];
    final service = ref.read(liveApiServiceProvider);

    setState(() {
      _phase = _SessionPhase.asking;
      _lastOutputTranscription = null;
      _lastInputTranscription = null;
      _lastEvaluationText = null;
      _lastScore = 0;
    });

    final cueInstruction = _currentCueLevel.promptInstruction;
    final cueLabel = CueingLadderService.sinhalaLabel(_currentCueLevel);

    service.sendText(
      'Picture ${step + 1}: ${item.emoji} '
      'Answer: "${item.sinhala}" (${item.english}). '
      'CUE LEVEL ${_currentCueLevel.levelIndex} ($cueLabel): $cueInstruction',
    );
  }

  void _startMicStream() async {
    if (_isMicStreaming || _phase != _SessionPhase.listening) return;
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
    ref.read(liveApiServiceProvider).sendAudioStreamEnd();

    setState(() {
      _isMicStreaming = false;
      _phase = _SessionPhase.evaluating;
    });
  }

  void _nextExercise() {
    final step = ref.read(_sessionStepProvider);
    final exercises = ref.read(_sessionExercisesProvider);

    // If patient got it wrong and we can escalate the cue level...
    if (!_wasCorrect && _currentCueLevel != CueLevel.fullModel) {
      final nextLevel = _cueLadder.nextLevel(_currentCueLevel, _lastScore);
      if (nextLevel != _currentCueLevel) {
        setState(() {
          _currentCueLevel = nextLevel;
          _cueRetries++;
        });
        _askCurrentItem();
        return;
      }
    }

    // Reset cue level for next item
    _currentCueLevel = CueLevel.freeRecall;
    _cueRetries = 0;

    if (step + 1 >= exercises.length) {
      ref.read(liveApiServiceProvider).disconnect();
      setState(() => _phase = _SessionPhase.completed);
      return;
    }

    ref.read(_sessionStepProvider.notifier).update((s) => s + 1);
    _askCurrentItem();
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(_sessionStepProvider);
    final exercises = ref.watch(_sessionExercisesProvider);
    final results = ref.watch(_sessionResultsProvider);

    if (step >= exercises.length || _phase == _SessionPhase.completed) {
      return _buildCompletionScreen(context, results);
    }

    final item = exercises[step];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('අභ්‍යාස සැසිය'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              SessionProgressBar(completed: step, total: exercises.length),
              const SizedBox(height: 16),
              if (_phase == _SessionPhase.connecting)
                const Expanded(
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
                )
              else ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusLg),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.divider,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(item.emoji,
                                style: const TextStyle(fontSize: 100)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(item.english,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        _buildCueLevelBadge(),
                        const SizedBox(height: 4),
                        _buildStruggleBadge(),
                        const SizedBox(height: 8),
                        _buildPhaseChip(),
                        const SizedBox(height: 8),
                        if (_lastOutputTranscription != null)
                          _buildBubble(_lastOutputTranscription!, false),
                        if (_lastInputTranscription != null)
                          _buildBubble(_lastInputTranscription!, true),
                        if (_phase == _SessionPhase.result &&
                            _lastEvaluationText != null)
                          _buildEvaluationCard(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBottomAction(),
              ],
            ],
          ),
        ),
      ),
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

  Widget _buildStruggleBadge() {
    if (_phase != _SessionPhase.result) return const SizedBox.shrink();
    if (_lastStruggleLevel == StruggleLevel.none) return const SizedBox.shrink();

    final struggleColors = <StruggleLevel, Color>{
      StruggleLevel.subtle: Colors.yellow.shade700,
      StruggleLevel.moderate: Colors.orange,
      StruggleLevel.significant: Colors.deepOrange,
      StruggleLevel.severe: Colors.red,
    };
    final struggleIcons = <StruggleLevel, IconData>{
      StruggleLevel.subtle: Icons.sentiment_neutral,
      StruggleLevel.moderate: Icons.sentiment_dissatisfied,
      StruggleLevel.significant: Icons.sentiment_very_dissatisfied,
      StruggleLevel.severe: Icons.error_outline,
    };
    final color = struggleColors[_lastStruggleLevel] ?? Colors.orange;
    final icon = struggleIcons[_lastStruggleLevel] ?? Icons.info_outline;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                _lastStruggleLevel.description,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseChip() {
    String text;
    IconData icon;
    Color color;

    switch (_phase) {
      case _SessionPhase.asking:
        text = 'අසමින්...';
        icon = Icons.volume_up;
        color = AppColors.primary;
      case _SessionPhase.listening:
        text = _isMicStreaming ? 'කියමින්...' : 'සවන් දෙමින්...';
        icon = _isMicStreaming ? Icons.mic : Icons.mic_none;
        color = _isMicStreaming ? Colors.green : AppColors.textSecondary;
      case _SessionPhase.evaluating:
        text = 'ඇගයීම...';
        icon = Icons.psychology;
        color = Colors.orange;
      case _SessionPhase.result:
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

  Widget _buildBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isUser ? Colors.white : AppColors.textPrimary,
              ),
        ),
      ),
    );
  }

  Widget _buildEvaluationCard() {
    return Card(
      color: _wasCorrect ? Colors.green.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              _wasCorrect ? Icons.check_circle : Icons.info,
              color: _wasCorrect ? Colors.green : Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _lastEvaluationText?.replaceAll(RegExp(r'\[\d+\]'), '').trim() ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    switch (_phase) {
      case _SessionPhase.asking:
      case _SessionPhase.evaluating:
        return const Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        );
      case _SessionPhase.listening:
        return GestureDetector(
          onTapDown: (_) => _startMicStream(),
          onTapUp: (_) => _stopMicStream(),
          onTapCancel: _stopMicStream,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 72,
            height: 72,
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
              size: 36,
              color: Colors.white,
            ),
          ),
        );
      case _SessionPhase.result:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('නවත්වන්න'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: _nextExercise,
                child: const Text('ඊළඟට'),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCompletionScreen(
      BuildContext context, List<ExerciseResult> results) {
    final avgScore = results.isEmpty
        ? 0.0
        : results.fold(0.0, (s, r) => s + r.score) / results.length;
    final correct = results.where((r) => r.isCorrect).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('සැසිය සම්පූර්ණයි'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Text(
                'අභ්‍යාස සැසිය සම්පූර්ණයි!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ScoreBadge(percentage: avgScore, size: 140),
              const SizedBox(height: 16),
              Text(
                '${correct}/${results.length} නිවැරදියි',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (_isSaving)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () {
                              ref.read(_sessionStepProvider.notifier).state = 0;
                              ref.read(_sessionResultsProvider.notifier).state = [];
                              ref.read(_sessionIdProvider.notifier).state = null;
                            },
                      child: const Text('නැවත'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving
                          ? null
                          : () => _completeSession(avgScore, results.length),
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

  Future<void> _completeSession(double avgScore, int totalDone) async {
    setState(() => _isSaving = true);
    final sessionId = ref.read(_sessionIdProvider);
    if (sessionId != null) {
      await ref.read(sessionRepositoryProvider).completeSession(
        sessionId,
        averageScore: avgScore,
        completedExercises: totalDone,
      );
    }
    if (mounted) {
      ref.read(_sessionStepProvider.notifier).state = 0;
      ref.read(_sessionResultsProvider.notifier).state = [];
      ref.read(_sessionIdProvider.notifier).state = null;
      context.go(AppRoutes.home);
    }
  }
}
