import React, { useEffect, useState } from 'react';

interface Props {
  cycles: number;
  subtitles: string;
}

type Phase = 'inhale' | 'hold' | 'exhale';

export const BreathingWidget: React.FC<Props> = ({ cycles, subtitles }) => {
  const [phase, setPhase] = useState<Phase>('inhale');
  const [cycleCount, setCycleCount] = useState(0);

  useEffect(() => {
    let timeout: number;

    const runCycle = () => {
      if (cycleCount >= cycles) return;

      setPhase('inhale');
      // Trigger haptic if available
      if (navigator.vibrate) navigator.vibrate(200);

      timeout = window.setTimeout(() => {
        setPhase('hold');
        
        timeout = window.setTimeout(() => {
          setPhase('exhale');
          if (navigator.vibrate) navigator.vibrate([100, 50, 100]);
          
          timeout = window.setTimeout(() => {
            setCycleCount(c => c + 1);
          }, 6000); // Exhale duration
        }, 4000); // Hold duration
      }, 4000); // Inhale duration
    };

    runCycle();

    return () => clearTimeout(timeout);
  }, [cycleCount, cycles]);

  const getCircleClasses = () => {
    switch (phase) {
      case 'inhale': return 'scale-150 bg-blue-400 transition-all duration-[4000ms] ease-in-out';
      case 'hold': return 'scale-150 bg-green-400 transition-colors duration-500';
      case 'exhale': return 'scale-100 bg-blue-200 transition-all duration-[6000ms] ease-in-out';
      default: return 'scale-100 bg-blue-200';
    }
  };

  const getInstruction = () => {
    switch (phase) {
      case 'inhale': return 'Breathe In...';
      case 'hold': return 'Hold...';
      case 'exhale': return 'Breathe Out...';
    }
  };

  return (
    <div className="flex flex-col items-center justify-center h-full w-full bg-slate-900 text-white animate-in fade-in duration-700">
      <div className="mb-16 text-2xl font-light tracking-widest opacity-80">
        Cycle {Math.min(cycleCount + 1, cycles)} of {cycles}
      </div>
      
      <div className="relative w-64 h-64 flex items-center justify-center mb-16">
        <div className={`absolute w-48 h-48 rounded-full opacity-50 ${getCircleClasses()}`}></div>
        <div className="relative z-10 text-3xl font-medium drop-shadow-md">
          {getInstruction()}
        </div>
      </div>

      <div className="absolute bottom-12 w-full text-center px-8">
         <p className="text-2xl text-slate-300">{subtitles}</p>
      </div>
    </div>
  );
};
