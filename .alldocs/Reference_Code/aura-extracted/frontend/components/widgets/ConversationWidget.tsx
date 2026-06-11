import React from 'react';
import { Mic } from 'lucide-react';

interface Props {
  subtitles: string;
  userTranscript: string;
}

export const ConversationWidget: React.FC<Props> = ({ subtitles, userTranscript }) => {
  return (
    <div className="flex flex-col items-center justify-center h-full w-full p-8 animate-in fade-in duration-500">
      {/* Avatar Area */}
      <div className="relative mb-12">
        <div className="w-48 h-48 rounded-full bg-blue-100 flex items-center justify-center shadow-lg relative z-10">
           <div className="w-32 h-32 rounded-full bg-blue-500 animate-pulse opacity-80"></div>
        </div>
        {/* Decorative rings */}
        <div className="absolute inset-0 rounded-full border-4 border-blue-200 animate-ping opacity-20"></div>
      </div>

      {/* Subtitles Area */}
      <div className="w-full max-w-2xl text-center space-y-6">
        <div className="min-h-[100px] flex items-center justify-center">
          <p className="text-3xl md:text-4xl font-medium text-slate-800 leading-relaxed">
            {subtitles || "..."}
          </p>
        </div>
        
        {/* User Feedback */}
        <div className="flex items-center justify-center space-x-2 text-slate-400 min-h-[40px]">
          {userTranscript ? (
            <>
              <Mic size={16} className="animate-pulse text-blue-400" />
              <p className="text-lg italic">"{userTranscript}"</p>
            </>
          ) : (
            <div className="flex space-x-1">
              <div className="w-2 h-2 bg-slate-300 rounded-full animate-bounce" style={{ animationDelay: '0ms' }}></div>
              <div className="w-2 h-2 bg-slate-300 rounded-full animate-bounce" style={{ animationDelay: '150ms' }}></div>
              <div className="w-2 h-2 bg-slate-300 rounded-full animate-bounce" style={{ animationDelay: '300ms' }}></div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
