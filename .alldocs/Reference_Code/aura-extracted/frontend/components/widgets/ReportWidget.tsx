import React from 'react';
import { CheckCircle2, Award, Calendar } from 'lucide-react';

interface Props {
  summaryWins: string[];
  onClose: () => void;
}

export const ReportWidget: React.FC<Props> = ({ summaryWins, onClose }) => {
  return (
    <div className="flex flex-col items-center justify-center h-full w-full p-6 bg-gradient-to-b from-blue-50 to-white animate-in zoom-in-95 duration-500">
      
      <div className="w-20 h-20 bg-green-100 text-green-600 rounded-full flex items-center justify-center mb-6 shadow-sm">
        <Award size={40} />
      </div>
      
      <h1 className="text-4xl font-bold text-slate-800 mb-2">Session Complete</h1>
      <p className="text-lg text-slate-500 mb-10">Great work today!</p>

      <div className="w-full max-w-md bg-white rounded-3xl shadow-xl border border-slate-100 p-8 mb-10">
        <h2 className="text-xl font-semibold text-slate-700 mb-6 flex items-center">
          <Calendar className="mr-2 text-blue-500" size={24} />
          Today's Wins
        </h2>
        
        <ul className="space-y-4">
          {summaryWins && summaryWins.length > 0 ? (
            summaryWins.map((win, idx) => (
              <li key={idx} className="flex items-start">
                <CheckCircle2 className="text-green-500 mr-3 mt-1 flex-shrink-0" size={20} />
                <span className="text-lg text-slate-700 leading-snug">{win}</span>
              </li>
            ))
          ) : (
            <li className="flex items-start">
              <CheckCircle2 className="text-green-500 mr-3 mt-1 flex-shrink-0" size={20} />
              <span className="text-lg text-slate-700 leading-snug">Completed a full therapy session.</span>
            </li>
          )}
        </ul>
      </div>

      <button 
        onClick={onClose}
        className="px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-full text-xl font-medium shadow-lg shadow-blue-200 transition-transform active:scale-95"
      >
        See you tomorrow
      </button>
    </div>
  );
};
