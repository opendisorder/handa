/// Domain model for a picture-naming exercise.
class Exercise {
  final int id;
  final int categoryId;
  final String imagePath;
  final String targetWordSi;
  final String targetWordTa;
  final String targetWordEn;
  final String? phoneticHint;
  final int difficulty;
  final bool isActive;

  const Exercise({
    required this.id,
    required this.categoryId,
    required this.imagePath,
    required this.targetWordSi,
    required this.targetWordTa,
    required this.targetWordEn,
    this.phoneticHint,
    this.difficulty = 1,
    this.isActive = true,
  });

  /// Get the target word in the specified language.
  String targetWordIn(String languageCode) {
    switch (languageCode) {
      case 'si': return targetWordSi;
      case 'ta': return targetWordTa;
      case 'en': return targetWordEn;
      default: return targetWordEn;
    }
  }
}
