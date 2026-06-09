/// Domain model for app settings (key-value pairs).
class AppSetting {
  final String key;
  final String value;
  final DateTime updatedAt;

  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });

  bool get boolValue => value == 'true';
  int? get intValue => int.tryParse(value);
  double? get doubleValue => double.tryParse(value);
}
