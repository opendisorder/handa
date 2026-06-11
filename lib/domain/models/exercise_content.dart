/// Exercise content models — categories and items for speech therapy practice.
///
/// Each [ExerciseItem] represents a single practice target:
/// a Sinhala word with its English translation, an emoji visual aid,
/// and an optional image URL for richer visual presentation.
library;

import 'package:flutter/material.dart';

/// A single practice target for picture-naming exercises.
class ExerciseItem {
  final String sinhala;
  final String english;
  final String emoji;
  final String? imageUrl;

  const ExerciseItem({
    required this.sinhala,
    required this.english,
    required this.emoji,
    this.imageUrl,
  });

  /// Construct with an auto-generated Picsum placeholder image.
  factory ExerciseItem.withImage({
    required String sinhala,
    required String english,
    required String emoji,
  }) {
    return ExerciseItem(
      sinhala: sinhala,
      english: english,
      emoji: emoji,
      imageUrl:
          'https://picsum.photos/seed/${sinhala.replaceAll(' ', '')}/200/200',
    );
  }
}

/// A category grouping related exercise items.
class ExerciseCategory {
  final String name;
  final String nameSi;
  final IconData icon;
  final List<ExerciseItem> items;

  const ExerciseCategory({
    required this.name,
    required this.nameSi,
    required this.icon,
    required this.items,
  });

  /// Returns the full curated exercise content library.
  ///
  /// Categories: animals, food, body, home, colors, numbers, family,
  /// weather, actions, emotions, clothing, places.
  static List<ExerciseCategory> allCategories() {
    return [
      // ── Animals ──────────────────────────────────────────────
      ExerciseCategory(
        name: 'Animals',
        nameSi: 'සතුන්',
        icon: Icons.pets,
        items: [
          ExerciseItem.withImage(sinhala: 'බල්ලා', english: 'dog', emoji: '🐕'),
          ExerciseItem.withImage(sinhala: 'පූසා', english: 'cat', emoji: '🐈'),
          ExerciseItem.withImage(sinhala: 'අලියා', english: 'elephant', emoji: '🐘'),
          ExerciseItem.withImage(sinhala: 'කුරුල්ලා', english: 'bird', emoji: '🐦'),
          ExerciseItem.withImage(sinhala: 'මාළුවා', english: 'fish', emoji: '🐟'),
          ExerciseItem.withImage(sinhala: 'බැටළුවා', english: 'sheep', emoji: '🐑'),
          ExerciseItem.withImage(sinhala: 'ගවයා', english: 'cow', emoji: '🐄'),
          ExerciseItem.withImage(sinhala: 'අශ්වයා', english: 'horse', emoji: '🐎'),
          ExerciseItem.withImage(sinhala: 'වඳුරා', english: 'monkey', emoji: '🐒'),
          ExerciseItem.withImage(sinhala: 'කැස්බෑවා', english: 'turtle', emoji: '🐢'),
        ],
      ),

      // ── Food ─────────────────────────────────────────────────
      ExerciseCategory(
        name: 'Food',
        nameSi: 'ආහාර',
        icon: Icons.restaurant,
        items: [
          ExerciseItem.withImage(sinhala: 'බත්', english: 'rice', emoji: '🍚'),
          ExerciseItem.withImage(sinhala: 'පාන්', english: 'bread', emoji: '🍞'),
          ExerciseItem.withImage(sinhala: 'කිරි', english: 'milk', emoji: '🥛'),
          ExerciseItem.withImage(sinhala: 'බිත්තර', english: 'egg', emoji: '🥚'),
          ExerciseItem.withImage(sinhala: 'කෙසෙල්', english: 'banana', emoji: '🍌'),
          ExerciseItem.withImage(sinhala: 'ජලය', english: 'water', emoji: '💧'),
          ExerciseItem.withImage(sinhala: 'ඇපල්', english: 'apple', emoji: '🍎'),
          ExerciseItem.withImage(sinhala: 'මාළු', english: 'fish (food)', emoji: '🐟'),
          ExerciseItem.withImage(sinhala: 'කුකුල් මස්', english: 'chicken', emoji: '🍗'),
          ExerciseItem.withImage(sinhala: 'යෝගට්', english: 'yogurt', emoji: '🥄'),
        ],
      ),

      // ── Body ─────────────────────────────────────────────────
      ExerciseCategory(
        name: 'Body',
        nameSi: 'ශරීරය',
        icon: Icons.accessibility_new,
        items: [
          ExerciseItem.withImage(sinhala: 'අත', english: 'hand', emoji: '🤚'),
          ExerciseItem.withImage(sinhala: 'කකුල', english: 'leg', emoji: '🦵'),
          ExerciseItem.withImage(sinhala: 'ඇස', english: 'eye', emoji: '👁️'),
          ExerciseItem.withImage(sinhala: 'කන', english: 'ear', emoji: '👂'),
          ExerciseItem.withImage(sinhala: 'මුඛය', english: 'mouth', emoji: '👄'),
          ExerciseItem.withImage(sinhala: 'නාසය', english: 'nose', emoji: '👃'),
          ExerciseItem.withImage(sinhala: 'හිස', english: 'head', emoji: '🗣️'),
          ExerciseItem.withImage(sinhala: 'ඇඟිල්ල', english: 'finger', emoji: '☝️'),
          ExerciseItem.withImage(sinhala: 'දත්', english: 'teeth', emoji: '🦷'),
          ExerciseItem.withImage(sinhala: 'දිව', english: 'tongue', emoji: '👅'),
        ],
      ),

      // ── Home ─────────────────────────────────────────────────
      ExerciseCategory(
        name: 'Home',
        nameSi: 'නිවස',
        icon: Icons.home,
        items: [
          ExerciseItem.withImage(sinhala: 'පුටුව', english: 'chair', emoji: '🪑'),
          ExerciseItem.withImage(sinhala: 'මේසය', english: 'table', emoji: '🪑'),
          ExerciseItem.withImage(sinhala: 'ඇඳ', english: 'bed', emoji: '🛏️'),
          ExerciseItem.withImage(sinhala: 'දොර', english: 'door', emoji: '🚪'),
          ExerciseItem.withImage(sinhala: 'ජනේලය', english: 'window', emoji: '🪟'),
          ExerciseItem.withImage(sinhala: 'පොත', english: 'book', emoji: '📖'),
          ExerciseItem.withImage(sinhala: 'පන්දම', english: 'lamp', emoji: '💡'),
          ExerciseItem.withImage(sinhala: 'තුවාය', english: 'towel', emoji: '🧴'),
          ExerciseItem.withImage(sinhala: 'කෝප්පය', english: 'cup', emoji: '☕'),
          ExerciseItem.withImage(sinhala: 'තහඩුව', english: 'plate', emoji: '🍽️'),
        ],
      ),

      // ── Colors ───────────────────────────────────────────────
      ExerciseCategory(
        name: 'Colors',
        nameSi: 'වර්ණ',
        icon: Icons.palette,
        items: [
          ExerciseItem.withImage(sinhala: 'රතු', english: 'red', emoji: '🔴'),
          ExerciseItem.withImage(sinhala: 'නිල්', english: 'blue', emoji: '🔵'),
          ExerciseItem.withImage(sinhala: 'කොළ', english: 'green', emoji: '🟢'),
          ExerciseItem.withImage(sinhala: 'කහ', english: 'yellow', emoji: '🟡'),
          ExerciseItem.withImage(sinhala: 'සුදු', english: 'white', emoji: '⚪'),
          ExerciseItem.withImage(sinhala: 'කළු', english: 'black', emoji: '⚫'),
          ExerciseItem.withImage(sinhala: 'දම්', english: 'purple', emoji: '🟣'),
          ExerciseItem.withImage(sinhala: 'තැඹිලි', english: 'orange', emoji: '🟠'),
        ],
      ),

      // ── Numbers ──────────────────────────────────────────────
      ExerciseCategory(
        name: 'Numbers',
        nameSi: 'අංක',
        icon: Icons.numbers,
        items: [
          ExerciseItem.withImage(sinhala: 'එක', english: 'one', emoji: '1️⃣'),
          ExerciseItem.withImage(sinhala: 'දෙක', english: 'two', emoji: '2️⃣'),
          ExerciseItem.withImage(sinhala: 'තුන', english: 'three', emoji: '3️⃣'),
          ExerciseItem.withImage(sinhala: 'හතර', english: 'four', emoji: '4️⃣'),
          ExerciseItem.withImage(sinhala: 'පහ', english: 'five', emoji: '5️⃣'),
          ExerciseItem.withImage(sinhala: 'හය', english: 'six', emoji: '6️⃣'),
          ExerciseItem.withImage(sinhala: 'හත', english: 'seven', emoji: '7️⃣'),
          ExerciseItem.withImage(sinhala: 'අට', english: 'eight', emoji: '8️⃣'),
          ExerciseItem.withImage(sinhala: 'නවය', english: 'nine', emoji: '9️⃣'),
          ExerciseItem.withImage(sinhala: 'දහය', english: 'ten', emoji: '🔟'),
        ],
      ),

      // ── Family ───────────────────────────────────────────────
      ExerciseCategory(
        name: 'Family',
        nameSi: 'පවුල',
        icon: Icons.family_restroom,
        items: [
          ExerciseItem.withImage(sinhala: 'අම්මා', english: 'mother', emoji: '👩'),
          ExerciseItem.withImage(sinhala: 'තාත්තා', english: 'father', emoji: '👨'),
          ExerciseItem.withImage(sinhala: 'අක්කා', english: 'elder sister', emoji: '👩‍🦰'),
          ExerciseItem.withImage(sinhala: 'අයියා', english: 'elder brother', emoji: '👨‍🦰'),
          ExerciseItem.withImage(sinhala: 'නංගි', english: 'younger sister', emoji: '👧'),
          ExerciseItem.withImage(sinhala: 'මල්ලි', english: 'younger brother', emoji: '👦'),
          ExerciseItem.withImage(sinhala: 'ආච්චි', english: 'grandmother', emoji: '👵'),
          ExerciseItem.withImage(sinhala: 'සීයා', english: 'grandfather', emoji: '👴'),
        ],
      ),

      // ── Weather ──────────────────────────────────────────────
      ExerciseCategory(
        name: 'Weather',
        nameSi: 'කාලගුණය',
        icon: Icons.wb_sunny,
        items: [
          ExerciseItem.withImage(sinhala: 'හිරු', english: 'sun', emoji: '☀️'),
          ExerciseItem.withImage(sinhala: 'වැස්ස', english: 'rain', emoji: '🌧️'),
          ExerciseItem.withImage(sinhala: 'වලාකුළු', english: 'cloud', emoji: '☁️'),
          ExerciseItem.withImage(sinhala: 'සුළඟ', english: 'wind', emoji: '🌬️'),
          ExerciseItem.withImage(sinhala: 'හිම', english: 'snow', emoji: '❄️'),
          ExerciseItem.withImage(sinhala: 'ගිගුරුම්', english: 'thunder', emoji: '⛈️'),
          ExerciseItem.withImage(sinhala: 'දේදුන්න', english: 'rainbow', emoji: '🌈'),
        ],
      ),

      // ── Emotions ─────────────────────────────────────────────
      ExerciseCategory(
        name: 'Emotions',
        nameSi: 'හැඟීම්',
        icon: Icons.emoji_emotions,
        items: [
          ExerciseItem.withImage(sinhala: 'සතුටු', english: 'happy', emoji: '😊'),
          ExerciseItem.withImage(sinhala: 'දුක', english: 'sad', emoji: '😢'),
          ExerciseItem.withImage(sinhala: 'තරහ', english: 'angry', emoji: '😡'),
          ExerciseItem.withImage(sinhala: 'බය', english: 'scared', emoji: '😨'),
          ExerciseItem.withImage(sinhala: 'හෙම්බිරි', english: 'surprised', emoji: '😲'),
          ExerciseItem.withImage(sinhala: 'වෙහෙස', english: 'tired', emoji: '😴'),
        ],
      ),

      // ── Clothing ─────────────────────────────────────────────
      ExerciseCategory(
        name: 'Clothing',
        nameSi: 'ඇඳුම්',
        icon: Icons.checkroom,
        items: [
          ExerciseItem.withImage(sinhala: 'කමිසය', english: 'shirt', emoji: '👕'),
          ExerciseItem.withImage(sinhala: 'කලිසම', english: 'pants', emoji: '👖'),
          ExerciseItem.withImage(sinhala: 'සාය', english: 'skirt', emoji: '👗'),
          ExerciseItem.withImage(sinhala: 'සපත්තු', english: 'shoes', emoji: '👟'),
          ExerciseItem.withImage(sinhala: 'තොප්පිය', english: 'hat', emoji: '🧢'),
          ExerciseItem.withImage(sinhala: 'මේස්', english: 'socks', emoji: '🧦'),
          ExerciseItem.withImage(sinhala: 'ස්කාෆ්', english: 'scarf', emoji: '🧣'),
        ],
      ),

      // ── Places ───────────────────────────────────────────────
      ExerciseCategory(
        name: 'Places',
        nameSi: 'ස්ථාන',
        icon: Icons.place,
        items: [
          ExerciseItem.withImage(sinhala: 'ගෙදර', english: 'home', emoji: '🏠'),
          ExerciseItem.withImage(sinhala: 'පාසල', english: 'school', emoji: '🏫'),
          ExerciseItem.withImage(sinhala: 'රෝහල', english: 'hospital', emoji: '🏥'),
          ExerciseItem.withImage(sinhala: 'වෙළඳසැල', english: 'shop', emoji: '🏪'),
          ExerciseItem.withImage(sinhala: 'පන්සල', english: 'temple', emoji: '🛕'),
          ExerciseItem.withImage(sinhala: 'උද්‍යානය', english: 'park', emoji: '🌳'),
          ExerciseItem.withImage(sinhala: 'වෙරළ', english: 'beach', emoji: '🏖️'),
        ],
      ),
    ];
  }

  /// Backward-compatible alias for screens that haven't migrated yet.
  static List<ExerciseCategory> sampleCategories() => allCategories();
}

/// Result of a single picture-naming exercise attempt.
///
/// Stores the target item, the score achieved, whether the attempt
/// was correct, and optional Gemini feedback text.
class ExerciseResult {
  final ExerciseItem item;
  final double score;
  final bool isCorrect;
  final String? feedback;

  const ExerciseResult({
    required this.item,
    required this.score,
    required this.isCorrect,
    this.feedback,
  });
}
