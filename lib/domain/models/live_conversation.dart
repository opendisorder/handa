/// Domain model for a Gemini Live conversation record.
class LiveConversation {
  final int id;
  final int sessionId;
  final String exerciseType;
  final int durationSeconds;
  final String userTranscript;
  final String aiFeedback;
  final double? score;
  final bool isSynced;
  final DateTime createdAt;

  const LiveConversation({
    required this.id,
    required this.sessionId,
    required this.exerciseType,
    required this.durationSeconds,
    required this.userTranscript,
    required this.aiFeedback,
    this.score,
    this.isSynced = false,
    required this.createdAt,
  });
}
