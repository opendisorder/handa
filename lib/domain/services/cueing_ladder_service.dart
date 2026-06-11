/// Cueing ladder service — 4-level progressive hint system for speech therapy.
///
/// When a patient struggles with picture-naming, the therapist escalates
/// through increasingly supportive cues:
///
/// | Level | Name | Strategy |
/// |-------|------|----------|
/// | 0 | Free Recall | Show picture only, ask "මෙය කුමක්ද?" |
/// | 1 | Phonetic Cue | Give first syllable sound |
/// | 2 | Syllable Breakdown | Say word in syllables slowly |
/// | 3 | Full Model | Say the word, patient repeats |
///
/// The ladder auto-advances when score < [advanceThreshold] (default: 60%).
library;

/// A single level on the cueing ladder.
enum CueLevel {
  freeRecall(0, 'Free Recall', ''),
  phoneticCue(1, 'Phonetic Cue', 'Give only the first syllable as a hint'),
  syllableBreakdown(2, 'Syllable Breakdown',
      'Break the word into syllables and say each one slowly'),
  fullModel(3, 'Full Model',
      'Say the full word clearly and ask the patient to repeat after you');

  final int levelIndex;
  final String label;
  final String instruction;

  const CueLevel(this.levelIndex, this.label, this.instruction);

  /// The instruction line sent to Gemini for this cue level.
  String get promptInstruction {
    if (this == freeRecall) {
      return 'Ask "මෙය කුමක්ද?" in a natural voice. Give NO hints.';
    }
    return instruction;
  }
}

/// Manages cue progression for a single exercise item.
class CueingLadderService {
  /// The threshold below which the patient advances to the next cue level.
  final double advanceThreshold;

  CueingLadderService({this.advanceThreshold = 60.0});

  /// Returns the appropriate cue level given the current level and score.
  ///
  /// * If [score] >= [advanceThreshold] → return [currentLevel] (no escalation).
  ///   The patient is close enough; retry at same level.
  /// * If [score] < [advanceThreshold] and [currentLevel] is not max → advance.
  /// * If [currentLevel] is max → stay at max (already gave full model).
  CueLevel nextLevel(CueLevel currentLevel, double score) {
    if (score >= advanceThreshold) return currentLevel;
    if (currentLevel == CueLevel.fullModel) return currentLevel;
    return CueLevel.values[currentLevel.levelIndex + 1];
  }

  /// Returns true if the patient succeeded at the current level
  /// (score >= advanceThreshold).
  bool isSuccessful(double score) => score >= advanceThreshold;

  /// Returns true if [score] < [advanceThreshold] and there are higher levels.
  bool shouldEscalate(CueLevel currentLevel, double score) {
    return score < advanceThreshold && currentLevel != CueLevel.fullModel;
  }

  /// Human-readable Sinhala label for the current cue level.
  static String sinhalaLabel(CueLevel level) {
    switch (level) {
      case CueLevel.freeRecall:
        return 'මතකයෙන් කියන්න';
      case CueLevel.phoneticCue:
        return 'මුල් අකුර ඉඟියක් ලෙස';
      case CueLevel.syllableBreakdown:
        return 'අක්ෂර වලට වෙන් කරන්න';
      case CueLevel.fullModel:
        return 'මා සමඟ කියන්න';
    }
  }
}
