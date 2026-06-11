import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gemini_live_fork/gemini_live.dart' as live;

import '../../core/constants/app_constants.dart';
import 'adc_token_provider.dart';

/// Callback types for the Live API service.
typedef OnLiveMessage = void Function(live.LiveServerMessage message);
typedef OnLiveError = void Function(Object error, StackTrace stack);
typedef OnLiveConnectionState = void Function(bool connected);
typedef OnLiveAudioData = void Function(List<int> audioData);

/// Service for connecting to the Vertex AI Gemini Live API.
///
/// Uses the vendored [gemini_live_fork] package with OAuth2 Bearer token
/// authentication. Token is obtained from [AdcTokenProvider] which uses
/// the `gcloud` CLI (dev) or a [BackendTokenProvider] (production).
class LiveApiService {
  live.LiveSession? _session;
  live.GoogleGenAI? _genAI;
  bool _isConnecting = false;

  /// Token provider for OAuth2 Bearer token auth.
  final AdcTokenProvider _tokenProvider;

  /// Whether to auto-refresh the token on a timer.
  final bool _autoRefresh;

  LiveApiService({
    AdcTokenProvider? tokenProvider,
    bool autoRefresh = true,
  }) : _tokenProvider = tokenProvider ?? AdcTokenProvider(),
       _autoRefresh = autoRefresh;

  bool get isConnected => _session != null && !_session!.isClosed;
  bool get isConnecting => _isConnecting;
  live.LiveSession? get session => _session;

  StreamController<live.LiveServerMessage>? _messageController;
  Stream<live.LiveServerMessage>? get messages => _messageController?.stream;

  /// Connects to the Vertex AI Gemini Live API via WebSocket.
  ///
  /// [systemInstruction] — the Thilina/AURA system prompt text.
  /// [tools] — optional function declarations for tool calling.
  /// [onMessage] — callback for JSON server messages.
  /// [onAudioData] — callback for raw binary PCM audio frames from the server.
  /// [onError] — callback for errors.
  /// [onState] — callback for connection state changes.
  Future<void> connect({
    required String systemInstruction,
    List<live.Tool>? tools,
    OnLiveMessage? onMessage,
    OnLiveAudioData? onAudioData,
    OnLiveError? onError,
    OnLiveConnectionState? onState,
  }) async {
    if (_isConnecting) return;
    _isConnecting = true;
    onState?.call(false);

    try {
      // Start auto-refresh if requested.
      if (_autoRefresh) {
        _tokenProvider.startAutoRefresh();
      }

      // Get the current access token.
      final accessToken = await _tokenProvider.getToken();

      // Initialize the Vertex AI Live client with OAuth2 Bearer auth.
      _genAI = live.GoogleGenAI(
        accessToken: accessToken,
        projectId: AppConstants.gcpProjectId,
        location: AppConstants.gcpLocation,
      );

      _messageController = StreamController<live.LiveServerMessage>.broadcast();

      // Build full model path for Vertex AI.
      final modelPath =
          'projects/${AppConstants.gcpProjectId}/'
          'locations/${AppConstants.gcpLocation}/'
          'publishers/google/models/${AppConstants.liveApiModel}';

      final session = await _genAI!.live.connect(
        live.LiveConnectParameters(
          model: modelPath,
          tools: tools,
          config: live.GenerationConfig(
            temperature: 0.7,
            speechConfig: live.SpeechConfig(
              voiceConfig: live.VoiceConfig(
                prebuiltVoiceConfig: live.PrebuiltVoiceConfig(
                  voiceName: 'puck',
                ),
              ),
            ),
          ),
          systemInstruction: live.Content(
            parts: [live.Part(text: systemInstruction)],
          ),
          inputAudioTranscription: live.AudioTranscriptionConfig(
            languageCodes: ['en-US'],
          ),
          outputAudioTranscription: live.AudioTranscriptionConfig(
            languageCodes: ['en-US'],
          ),
          realtimeInputConfig: live.RealtimeInputConfig(
            automaticActivityDetection: live.AutomaticActivityDetection(
              disabled: false,
              startOfSpeechSensitivity:
                  live.StartSensitivity.START_SENSITIVITY_HIGH,
              endOfSpeechSensitivity:
                  live.EndSensitivity.END_SENSITIVITY_LOW,
              prefixPaddingMs: 300,
              silenceDurationMs: 600,
            ),
            activityHandling:
                live.ActivityHandling.START_OF_ACTIVITY_INTERRUPTS,
          ),
          callbacks: live.LiveCallbacks(
            onOpen: () {
              _isConnecting = false;
              onState?.call(true);
            },
            onMessage: (message) {
              _messageController?.add(message);
              onMessage?.call(message);
            },
            onAudioData: (audioData) {
              onAudioData?.call(audioData);
            },
            onError: (error, stack) {
              _isConnecting = false;
              onState?.call(false);
              onError?.call(error, stack);
            },
            onClose: (code, reason) {
              _isConnecting = false;
              _session = null;
              onState?.call(false);
            },
          ),
        ),
      );

      _session = session;
    } catch (error) {
      _isConnecting = false;
      onState?.call(false);
      debugPrint('[LiveApiService] Connection failed: $error');
      rethrow;
    }
  }

  /// Sends a client content turn with text.
  void sendText(String text) {
    if (!isConnected) return;
    _session!.sendText(text);
  }

  /// Sends realtime text input (not a full turn).
  void sendRealtimeText(String text) {
    if (!isConnected) return;
    _session!.sendRealtimeText(text);
  }

  /// Sends audio data to the server (base64-encoded in JSON via realtimeInput).
  void sendAudio(List<int> audioBytes) {
    if (!isConnected) return;
    _session!.sendAudio(audioBytes);
  }

  /// Signals the end of an audio stream.
  void sendAudioStreamEnd() {
    if (!isConnected) return;
    _session!.sendAudioStreamEnd();
  }

  /// Sends realtime input with optional audio, video, text, or stream end.
  void sendRealtimeInput({
    List<int>? audio,
    List<int>? video,
    String? text,
    bool? audioStreamEnd,
  }) {
    if (!isConnected) return;
    _session!.sendRealtimeInput(
      audio: audio != null
          ? live.Blob(mimeType: 'audio/pcm;rate=16000', data: base64Encode(audio))
          : null,
      video: video != null
          ? live.Blob(mimeType: 'image/jpeg', data: base64Encode(video))
          : null,
      text: text,
      audioStreamEnd: audioStreamEnd,
    );
  }

  /// Sends video frames to the server.
  void sendVideo(List<int> videoBytes, {String mimeType = 'image/jpeg'}) {
    if (!isConnected) return;
    _session!.sendVideo(videoBytes, mimeType: mimeType);
  }

  /// Sends a client content turn.
  void sendClientContent({
    List<live.Content>? turns,
    bool turnComplete = true,
  }) {
    if (!isConnected) return;
    _session!.sendClientContent(turns: turns, turnComplete: turnComplete);
  }

  /// Marks start of user activity (for explicit VAD).
  void sendActivityStart() {
    if (!isConnected) return;
    _session!.sendActivityStart();
  }

  /// Marks end of user activity (for explicit VAD).
  void sendActivityEnd() {
    if (!isConnected) return;
    _session!.sendActivityEnd();
  }

  /// Sends a tool/function response back to the model.
  void sendToolResponse({
    required String id,
    required String name,
    required Map<String, dynamic> response,
  }) {
    if (!isConnected) return;
    _session!.sendFunctionResponse(id: id, name: name, response: response);
  }

  /// Disconnects the Live session.
  Future<void> disconnect() async {
    _tokenProvider.stopAutoRefresh();
    await _session?.close();
    _session = null;
    _isConnecting = false;
    await _messageController?.close();
    _messageController = null;
  }

  /// Disposes all resources.
  void dispose() {
    _tokenProvider.dispose();
    _session?.close();
    _session = null;
    _messageController?.close();
    _messageController = null;
  }
}
