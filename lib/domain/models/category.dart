/// Domain model for an exercise category.
class Category {
  final int id;
  final String nameSi;
  final String nameTa;
  final String nameEn;
  final String descriptionSi;
  final String descriptionTa;
  final String descriptionEn;
  final String icon;
  final int sortOrder;
  final bool isActive;

  const Category({
    required this.id,
    required this.nameSi,
    required this.nameTa,
    required this.nameEn,
    required this.descriptionSi,
    required this.descriptionTa,
    required this.descriptionEn,
    this.icon = '',
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Get name in the specified language.
  String nameIn(String languageCode) {
    switch (languageCode) {
      case 'si': return nameSi;
      case 'ta': return nameTa;
      case 'en': return nameEn;
      default: return nameEn;
    }
  }

  /// Get description in the specified language.
  String descriptionIn(String languageCode) {
    switch (languageCode) {
      case 'si': return descriptionSi;
      case 'ta': return descriptionTa;
      case 'en': return descriptionEn;
      default: return descriptionEn;
    }
  }
}
