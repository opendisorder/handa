import React, { useRef, useEffect } from 'react';
import { useGeminiLive } from './hooks/useGeminiLive';
import { WidgetType } from './types';
import { ConversationWidget } from './components/widgets/ConversationWidget';
import { BreathingWidget } from './components/widgets/BreathingWidget';
import { ExerciseWidget } from './components/widgets/ExerciseWidget';
import { ReportWidget } from './components/widgets/ReportWidget';
import { Mic, Video, AlertCircle } from 'lucide-react';

const App: React.FC = () => {
  const { state, startSession, stopSession } = useGeminiLive();
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      stopSession();
    };
  }, [stopSession]);

  const handleStart = () => {
    if (videoRef.current && canvasRef.current) {
      startSession(videoRef.current, canvasRef.current);
    }
  };

  const renderWidget = () => {
    switch (state.activeWidget) {
      case WidgetType.WELCOME:
        return (
          <div className="flex flex-col items-center justify-center h-full p-8 text-center">
            <div className="w-24 h-24 bg-blue-100 rounded-full flex items-center justify-center mb-8 shadow-inner">
              <Mic className="text-blue-500" size={40} />
            </div>
            <h1 className="text-4xl font-bold text-slate-800 mb-4">AURA</h1>
            <p className="text-xl text-slate-500 mb-12 max-w-md">
              Your personal speech therapy companion. Find a quiet place and let's begin.
            </p>
            
            {state.error && (
              <div className="mb-8 p-4 bg-red-50 text-red-700 rounded-xl flex items-center max-w-md text-left">
                <AlertCircle className="mr-3 flex-shrink-0" size={24} />
                <p>{state.error}</p>
              </div>
            )}

            <button
              onClick={handleStart}
              disabled={state.isConnecting}
              className={`px-10 py-4 rounded-full text-xl font-medium text-white shadow-xl transition-all ${
                state.isConnecting 
                  ? 'bg-slate-400 cursor-not-allowed' 
                  : 'bg-blue-600 hover:bg-blue-700 hover:shadow-blue-200 active:scale-95'
              }`}
            >
              {state.isConnecting ? 'Connecting...' : 'Start Session'}
            </button>
            
            <div className="mt-8 flex items-center text-sm text-slate-400">
              <Video size={16} className="mr-2" />
              Camera used for observation only. No video is recorded.
            </div>
          </div>
        );
      
      case WidgetType.CONVERSATION:
        return (
          <ConversationWidget 
            subtitles={state.subtitles} 
            userTranscript={state.userTranscript} 
          />
        );
      
      case WidgetType.BREATHING:
        return (
          <BreathingWidget 
            cycles={state.widgetProps.cycles || 3} 
            subtitles={state.subtitles} 
          />
        );
      
      case WidgetType.EXERCISE:
        return (
          <ExerciseWidget 
            imageUrl={state.widgetProps.imageUrl} 
            targetWord={state.widgetProps.targetWord}
            subtitles={state.subtitles}
            userTranscript={state.userTranscript}
          />
        );
      
      case WidgetType.REPORT:
        return (
          <ReportWidget 
            summaryWins={state.widgetProps.summaryWins || []} 
            onClose={stopSession} 
          />
        );
        
      default:
        return null;
    }
  };

  return (
    <div className="relative w-full h-full bg-gradient-to-br from-slate-50 to-blue-50/30">
      {/* Hidden elements for camera capture */}
      <video ref={videoRef} className="hidden" playsInline muted />
      <canvas ref={canvasRef} className="hidden" />

      {/* Main UI Container */}
      <main className="w-full h-full flex items-center justify-center">
        {renderWidget()}
      </main>

      {/* Debug/Status overlay (optional, good for prototype) */}
      {state.isConnected && state.activeWidget !== WidgetType.REPORT && (
        <button 
          onClick={stopSession}
          className="absolute top-6 right-6 px-4 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-full text-sm font-medium transition-colors"
        >
          End Session
        </button>
      )}
    </div>
  );
};

export default App;
