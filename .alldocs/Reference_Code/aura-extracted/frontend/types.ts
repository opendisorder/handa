export enum WidgetType {
  WELCOME = 'WELCOME',
  CONVERSATION = 'CONVERSATION',
  BREATHING = 'BREATHING',
  EXERCISE = 'EXERCISE',
  REPORT = 'REPORT'
}

export interface AppState {
  activeWidget: WidgetType;
  widgetProps: any;
  subtitles: string;
  userTranscript: string;
  isConnected: boolean;
  isConnecting: boolean;
  error: string | null;
}

export interface BreathingProps {
  cycles: number;
}

export interface ExerciseProps {
  imageUrl: string;
  targetWord: string;
}

export interface ReportProps {
  summaryWins: string[];
}
