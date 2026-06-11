import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:gemini_live_fork/gemini_live.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/services/background_agent_orchestrator.dart';
import '../../../data/services/function_declarations.dart';
import '../../../data/services/tool_call_handler_service.dart';
import '../../providers/digital_brain_providers.dart';
import '../../providers/live_api_provider.dart';
import '../../widgets/common/live_audio_player.dart';

final _messagesProvider = StateProvider<List<_ChatMessage>>((ref) => []);
final _connectionStateProvider =
    StateProvider<_ConnectionState>((ref) => _ConnectionState.disconnected);

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  _ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

enum _ConnectionState { disconnected, connecting, connected }

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});
  @override
  ConsumerState<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final LiveAudioPlayer _audioPlayer = LiveAudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final _scrollController = ScrollController();
  StreamSubscription<Uint8List>? _audioStreamSubscription;

  bool _isMicStreaming = false;
  bool _isModelSpeaking = false;
  String? _pendingOutputText;
  int _audioChunksSent = 0;

  ToolCallHandlerService? _toolCallHandler;
  bool _disconnectOnEnd = false;

  @override
  void dispose() {
    _audioStreamSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _scrollController.dispose();
    if (!_disconnectOnEnd) {
      ref.read(liveApiServiceProvider).disconnect();
    }
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addMessage(String text, bool isUser) {
    ref.read(_messagesProvider.notifier).update(
      (s) => [...s, _ChatMessage(text: text, isUser: isUser)],
    );
    _scrollToBottom();
  }

  Future<void> _connect() async {
    if (ref.read(_connectionStateProvider) == _ConnectionState.connected) return;

    ref.read(_connectionStateProvider.notifier).state =
        _ConnectionState.connecting;

    try {
      final service = ref.read(liveApiServiceProvider);

      // Initialize tool call handler with background agent integration
      final orchestrator = ref.read(backgroundAgentOrchestratorProvider);
      final sessionLogStore = ref.read(sessionLogStoreProvider);
      _toolCallHandler = ToolCallHandlerService(
        orchestrator: orchestrator,
        sessionLogStore: sessionLogStore,
        liveApiService: service,
        onUiAction: (name, args) {
          debugPrint('[ConversationScreen] UI action: $name $args');
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
          if (mounted) {
            ref.read(_connectionStateProvider.notifier).state = connected
                ? _ConnectionState.connected
                : _ConnectionState.disconnected;
          }
        },
      );

      if (mounted) {
        ref.read(_connectionStateProvider.notifier).state =
            _ConnectionState.connected;
      }
    } catch (e) {
      if (mounted) {
        ref.read(_connectionStateProvider.notifier).state =
            _ConnectionState.disconnected;
        _addMessage('සම්බන්ධ වීමට අපොහොසත් විය: $e', false);
      }
    }
  }

  Future<String> _buildSystemPrompt() async {
    final digitalBrain = ref.read(digitalBrainServiceProvider);
    final memoryBlock = await digitalBrain.buildMemoryBlock();
    final memorySection = memoryBlock.isNotEmpty
        ? '\n$memoryBlock\n'
        : '';
    return '''${memorySection}You are a friendly Sinhala conversation partner for a stroke patient.
The user is recovering from a stroke and practicing Sinhala speech.
Rules:
- Speak clearly and slowly in Sinhala
- Use simple vocabulary and short sentences
- Ask one question at a time
- Be encouraging and patient
- If you don't understand, gently ask them to repeat
- Never say "wrong" or "incorrect"
- Topics: family, weather, food, hobbies, daily routine
Keep responses to 1-2 sentences. Always be warm.''';
  }

  void _handleMessage(LiveServerMessage message) {
    if (message.data != null) {
      _audioPlayer.appendBase64Chunk(message.data!);
    }

    if (message.serverContent?.outputTranscription?.text case final text?
        when text.isNotEmpty) {
      _pendingOutputText = text;
    }
    if (message.serverContent?.inputTranscription?.text case final text?
        when text.isNotEmpty) {
      _addMessage(text, true);
    }

    final turnComplete = message.serverContent?.turnComplete ?? false;
    final generationComplete =
        message.serverContent?.generationComplete ?? false;
    final finished = turnComplete || generationComplete;

    if (finished && _pendingOutputText != null) {
      _addMessage(_pendingOutputText!, false);
      _pendingOutputText = null;
      _audioPlayer.playBufferedAudio();
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

  void _startMicStream() async {
    if (_isMicStreaming) return;
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

    setState(() => _isMicStreaming = false);
  }

  void _sendTextMessage(String text) {
    ref.read(liveApiServiceProvider).sendText(text);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(_messagesProvider);
    final connectionState = ref.watch(_connectionStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('කතා කරමු'),
        actions: [
          if (connectionState == _ConnectionState.connected)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const Chip(
                avatar: Icon(Icons.circle, size: 10, color: Colors.green),
                label: Text('සම්බන්ධයි'),
                visualDensity: VisualDensity.compact,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref.read(_messagesProvider.notifier).state = [],
            tooltip: 'සංවාදය මකන්න',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (connectionState == _ConnectionState.disconnected &&
                messages.isEmpty)
              ..._buildEmptyState()
            else if (connectionState == _ConnectionState.connecting)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('සම්බන්ධ වෙමින්...'),
                    ],
                  ),
                ),
              )
            else ...[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  itemCount: messages.length,
                  itemBuilder: (context, index) =>
                      _buildMessageBubble(messages[index]),
                ),
              ),
              _buildInputBar(connectionState),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEmptyState() {
    return [
      const Spacer(),
      Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(Icons.chat_rounded,
                  size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text('කතා කරමු!',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'ඔබේ දවස ගැන කියන්න,\nනැතහොත් ඕනෑම දෙයක් ගැන කතා කරන්න',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _connect,
              icon: const Icon(Icons.wifi_tethering, size: 28),
              label: const Text('සම්බන්ධ වන්න',
                  style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 24),
            _buildSuggestionChip('ආයුබෝවන්! කොහොමද?'),
            const SizedBox(height: 8),
            _buildSuggestionChip('අද කාලගුණය හොඳයි'),
            const SizedBox(height: 8),
            _buildSuggestionChip('මම අද උදේ ආහාර ගත්තා'),
          ],
        ),
      ),
      const Spacer(),
    ];
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      onPressed: () {
        if (ref.read(_connectionStateProvider) != _ConnectionState.connected) {
          return;
        }
        _addMessage(text, true);
        _sendTextMessage(text);
      },
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd).copyWith(
            bottomRight: message.isUser ? Radius.zero : null,
            bottomLeft: message.isUser ? null : Radius.zero,
          ),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: message.isUser ? Colors.white : AppColors.textPrimary,
              ),
        ),
      ),
    );
  }

  Widget _buildInputBar(_ConnectionState connectionState) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.divider.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (connectionState != _ConnectionState.connected)
              Expanded(
                child: FilledButton.icon(
                  onPressed: _connect,
                  icon: const Icon(Icons.wifi_tethering),
                  label: const Text('සම්බන්ධ වන්න'),
                ),
              )
            else ...[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isMicStreaming ? Colors.red : AppColors.primary,
                  ),
                  child: IconButton(
                    onPressed: _isMicStreaming ? _stopMicStream : _startMicStream,
                    icon: Icon(
                      _isMicStreaming
                          ? Icons.stop
                          : Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 56,
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Text message...',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isEmpty) return;
                      _addMessage(text.trim(), true);
                      _sendTextMessage(text.trim());
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 24),
                  onPressed: () {
                    ref.read(liveApiServiceProvider).sendText(
                      'Hello',
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
