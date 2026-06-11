import React from 'react';

interface Props {
  imageUrl: string;
  targetWord: string;
  subtitles: string;
  userTranscript: string;
}

export const ExerciseWidget: React.FC<Props> = ({ imageUrl, targetWord, subtitles, userTranscript }) => {
  return (
    <div className="flex flex-col items-center justify-between h-full w-full p-8 bg-white animate-in slide-in-from-bottom-8 duration-500">
      
      <div className="w-full flex justify-center pt-8">
        <span className="px-4 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-semibold uppercase tracking-wider">
          Naming Exercise
        </span>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center w-full max-w-md">
        <div className="w-full aspect-square rounded-2xl overflow-hidden shadow-2xl border-4 border-slate-100 mb-8 relative bg-slate-200">
          {/* Using a key to force re-render if URL changes, though React usually handles it */}
          <img 
            key={imageUrl}
            src={imageUrl} 
            alt="Exercise target" 
            className="w-full h-full object-cover"
            onError={(e) => {
              // Fallback if picsum fails
              (e.target as HTMLImageElement).src = 'https://picsum.photos/400/400?grayscale';
            }}
          />
        </div>
        
        {/* Subtitles directly related to the exercise */}
        <div className="text-center min-h-[80px]">
           <p className="text-3xl font-medium text-slate-800">{subtitles || "What is this?"}</p>
        </div>
      </div>

      {/* User Feedback Area */}
      <div className="w-full pb-8 flex justify-center">
         <div className="bg-slate-50 px-6 py-3 rounded-2xl border border-slate-200 min-w-[250px] text-center shadow-inner">
            <p className="text-sm text-slate-400 mb-1 uppercase tracking-wide">You said</p>
            <p className="text-xl text-slate-700 font-medium min-h-[30px]">
              {userTranscript || "..."}
            </p>
         </div>
      </div>
    </div>
  );
};
