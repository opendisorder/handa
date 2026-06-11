import { useState, useRef, useCallback } from 'react';
import { GoogleGenAI, LiveServerMessage, Modality } from '@google/genai';
import { WidgetType, AppState } from '../types';
import { LIVE_API_MODEL_NAME, SYSTEM_INSTRUCTION, TOOLS } from '../constants';
import { decode, decodeAudioData, createBlob, blobToBase64 } from '../services/audioUtils';

const FRAME_RATE = 1; // 1 frame per second as per PRD
const JPEG_QUALITY = 0.5;

export function useGeminiLive() {
  const [state, setState] = useState<AppState>({
    activeWidget: WidgetType.WELCOME,
    widgetProps: {},
    subtitles: '',
    userTranscript: '',
    isConnected: false,
    isConnecting: false,
    error: null,
  });

  const sessionRef = useRef<any>(null);
  const audioContextsRef = useRef<{ input?: AudioContext; output?: AudioContext }>({});
  const streamRef = useRef<MediaStream | null>(null);
  const sourcesRef = useRef<Set<AudioBufferSourceNode>>(new Set());
  const nextStartTimeRef = useRef<number>(0);
  const videoIntervalRef = useRef<number | null>(null);
  
  // Transcription buffers
  const currentInputTranscriptionRef = useRef('');
  const currentOutputTranscriptionRef = useRef('');

  const updateState = useCallback((updates: Partial<AppState>) => {
    setState((prev) => ({ ...prev, ...updates }));
  }, []);

  const handleToolCall = useCallback((fc: any, sessionPromise: Promise<any>) => {
    console.log('Tool called:', fc.name, fc.args);
    
    let result = "ok";
    
    switch (fc.name) {
      case 'show_conversation_widget':
        updateState({ activeWidget: WidgetType.CONVERSATION, widgetProps: {} });
        break;
      case 'show_breathing_widget':
        updateState({ activeWidget: WidgetType.BREATHING, widgetProps: fc.args });
        break;
      case 'show_exercise_widget':
        updateState({ activeWidget: WidgetType.EXERCISE, widgetProps: fc.args });
        break;
      case 'end_session':
        updateState({ activeWidget: WidgetType.REPORT, widgetProps: fc.args });
        break;
      default:
        result = "unknown function";
        console.warn('Unknown tool call:', fc.name);
    }

    // Send response back to model
    sessionPromise.then((session) => {
      session.sendToolResponse({
        functionResponses: {
          id: fc.id,
          name: fc.name,
          response: { result },
        }
      });
    });
  }, [updateState]);

  const startSession = useCallback(async (videoEl: HTMLVideoElement, canvasEl: HTMLCanvasElement) => {
    if (!process.env.API_KEY) {
      updateState({ error: "API_KEY environment variable is missing." });
      return;
    }

    updateState({ isConnecting: true, error: null });

    try {
      const ai = new GoogleGenAI({ apiKey: process.env.API_KEY, vertexai: true });
      
      // Setup Audio Contexts
      const inputAudioContext = new (window.AudioContext || (window as any).webkitAudioContext)({ sampleRate: 16000 });
      const outputAudioContext = new (window.AudioContext || (window as any).webkitAudioContext)({ sampleRate: 24000 });
      audioContextsRef.current = { input: inputAudioContext, output: outputAudioContext };
      const outputNode = outputAudioContext.createGain();
      outputNode.connect(outputAudioContext.destination);

      // Get Media Stream (Audio + Video)
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true, video: true });
      streamRef.current = stream;
      
      // Attach video to element for capturing frames
      videoEl.srcObject = stream;
      await videoEl.play();

      const sessionPromise = ai.live.connect({
        model: LIVE_API_MODEL_NAME,
        callbacks: {
          onopen: () => {
            console.log('Live API Connected');
            updateState({ isConnected: true, isConnecting: false, activeWidget: WidgetType.CONVERSATION });
            
            // 1. Setup Audio Streaming
            const source = inputAudioContext.createMediaStreamSource(stream);
            const scriptProcessor = inputAudioContext.createScriptProcessor(4096, 1, 1);
            scriptProcessor.onaudioprocess = (audioProcessingEvent) => {
              const inputData = audioProcessingEvent.inputBuffer.getChannelData(0);
              const pcmBlob = createBlob(inputData);
              sessionPromise.then((session) => {
                session.sendRealtimeInput({ media: pcmBlob });
              });
            };
            source.connect(scriptProcessor);
            scriptProcessor.connect(inputAudioContext.destination);

            // 2. Setup Video Streaming (1 fps)
            const ctx = canvasEl.getContext('2d');
            if (ctx) {
              videoIntervalRef.current = window.setInterval(() => {
                canvasEl.width = videoEl.videoWidth;
                canvasEl.height = videoEl.videoHeight;
                ctx.drawImage(videoEl, 0, 0, videoEl.videoWidth, videoEl.videoHeight);
                canvasEl.toBlob(
                  async (blob) => {
                    if (blob) {
                      const base64Data = await blobToBase64(blob);
                      sessionPromise.then((session) => {
                        session.sendRealtimeInput({
                          media: { data: base64Data, mimeType: 'image/jpeg' }
                        });
                      });
                    }
                  },
                  'image/jpeg',
                  JPEG_QUALITY
                );
              }, 1000 / FRAME_RATE);
            }
          },
          onmessage: async (message: LiveServerMessage) => {
            // Handle Tool Calls
            if (message.toolCall) {
              for (const fc of message.toolCall.functionCalls) {
                handleToolCall(fc, sessionPromise);
              }
            }

            // Handle Transcriptions
            if (message.serverContent?.outputTranscription) {
              currentOutputTranscriptionRef.current += message.serverContent.outputTranscription.text;
              updateState({ subtitles: currentOutputTranscriptionRef.current });
            } else if (message.serverContent?.inputTranscription) {
              currentInputTranscriptionRef.current += message.serverContent.inputTranscription.text;
              updateState({ userTranscript: currentInputTranscriptionRef.current });
            }

            if (message.serverContent?.turnComplete) {
              currentInputTranscriptionRef.current = '';
              currentOutputTranscriptionRef.current = '';
            }

            // Handle Audio Output
            const base64EncodedAudioString = message.serverContent?.modelTurn?.parts[0]?.inlineData?.data;
            if (base64EncodedAudioString) {
              nextStartTimeRef.current = Math.max(nextStartTimeRef.current, outputAudioContext.currentTime);
              const audioBuffer = await decodeAudioData(
                decode(base64EncodedAudioString),
                outputAudioContext,
                24000,
                1,
              );
              const source = outputAudioContext.createBufferSource();
              source.buffer = audioBuffer;
              source.connect(outputNode);
              source.addEventListener('ended', () => {
                sourcesRef.current.delete(source);
              });

              source.start(nextStartTimeRef.current);
              nextStartTimeRef.current += audioBuffer.duration;
              sourcesRef.current.add(source);
            }

            // Handle Interruption
            if (message.serverContent?.interrupted) {
              for (const source of sourcesRef.current.values()) {
                source.stop();
                sourcesRef.current.delete(source);
              }
              nextStartTimeRef.current = 0;
            }
          },
          onerror: (e: any) => {
            console.error('Live API Error:', e);
            updateState({ error: 'Connection error occurred.', isConnecting: false });
          },
          onclose: () => {
            console.log('Live API Closed');
            updateState({ isConnected: false, isConnecting: false });
            cleanup();
          },
        },
        config: {
          responseModalities: [Modality.AUDIO],
          speechConfig: {
            voiceConfig: { prebuiltVoiceConfig: { voiceName: 'Kore' } }, // Warm voice
          },
          systemInstruction: SYSTEM_INSTRUCTION,
          tools: [{ functionDeclarations: TOOLS }],
          outputAudioTranscription: {},
          inputAudioTranscription: {},
        },
      });

      sessionRef.current = sessionPromise;

    } catch (err: any) {
      console.error("Failed to start session:", err);
      updateState({ error: err.message || "Failed to start session", isConnecting: false });
      cleanup();
    }
  }, [handleToolCall, updateState]);

  const cleanup = useCallback(() => {
    if (videoIntervalRef.current) {
      clearInterval(videoIntervalRef.current);
      videoIntervalRef.current = null;
    }
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
      streamRef.current = null;
    }
    if (audioContextsRef.current.input) {
      audioContextsRef.current.input.close();
    }
    if (audioContextsRef.current.output) {
      audioContextsRef.current.output.close();
    }
    for (const source of sourcesRef.current.values()) {
      source.stop();
    }
    sourcesRef.current.clear();
    nextStartTimeRef.current = 0;
    
    if (sessionRef.current) {
       sessionRef.current.then((session: any) => {
           if(session && typeof session.close === 'function') {
               session.close();
           }
       }).catch(console.error);
       sessionRef.current = null;
    }
  }, []);

  const stopSession = useCallback(() => {
    cleanup();
    updateState({ isConnected: false, activeWidget: WidgetType.WELCOME });
  }, [cleanup, updateState]);

  return {
    state,
    startSession,
    stopSession
  };
}
