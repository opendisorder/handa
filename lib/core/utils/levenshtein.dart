/// Levenshtein distance for offline scoring of spoken responses.
///
/// Used as a fallback scoring mechanism when the app is offline.
/// Measures edit distance between user's spoken (transcribed) response
/// and the expected target word, normalized to a 0-100 percentage.
class LevenshteinDistance {
  /// Computes Levenshtein edit distance between two strings.
  static int distance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final aLen = a.length;
    final bLen = b.length;

    // Use two rows for O(n) memory
    List<int> prev = List.generate(bLen + 1, (i) => i);
    List<int> curr = List.filled(bLen + 1, 0);

    for (int i = 0; i < aLen; i++) {
      curr[0] = i + 1;
      for (int j = 0; j < bLen; j++) {
        final cost = a[i] == b[j] ? 0 : 1;
        curr[j + 1] = _min(
          prev[j + 1] + 1, // deletion
          curr[j] + 1,     // insertion
          prev[j] + cost,  // substitution
        );
      }
      // Swap rows
      final temp = prev;
      prev = curr;
      curr = temp;
    }

    return prev[bLen];
  }

  /// Computes similarity as a percentage (0-100).
  ///
  /// Returns 100 for exact match. The score is computed as:
  /// ```
  /// (1 - distance / max(len(a), len(b))) * 100
  /// ```
  /// Returns 0 if both strings are empty (no comparison possible).
  static double similarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 0;
    if (a.isEmpty || b.isEmpty) return 0;

    final maxLen = a.length > b.length ? a.length : b.length;
    if (maxLen == 0) return 0;

    final dist = distance(a, b);
    return ((1.0 - dist / maxLen) * 100).clamp(0, 100);
  }

  static int _min(int a, int b, int c) {
    final m = a < b ? a : b;
    return m < c ? m : c;
  }
}
