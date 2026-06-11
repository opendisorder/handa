// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handa_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameSiMeta = const VerificationMeta('nameSi');
  @override
  late final GeneratedColumn<String> nameSi = GeneratedColumn<String>(
    'name_si',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameTaMeta = const VerificationMeta('nameTa');
  @override
  late final GeneratedColumn<String> nameTa = GeneratedColumn<String>(
    'name_ta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionSiMeta = const VerificationMeta(
    'descriptionSi',
  );
  @override
  late final GeneratedColumn<String> descriptionSi = GeneratedColumn<String>(
    'description_si',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionTaMeta = const VerificationMeta(
    'descriptionTa',
  );
  @override
  late final GeneratedColumn<String> descriptionTa = GeneratedColumn<String>(
    'description_ta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionEnMeta = const VerificationMeta(
    'descriptionEn',
  );
  @override
  late final GeneratedColumn<String> descriptionEn = GeneratedColumn<String>(
    'description_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameSi,
    nameTa,
    nameEn,
    descriptionSi,
    descriptionTa,
    descriptionEn,
    icon,
    sortOrder,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_si')) {
      context.handle(
        _nameSiMeta,
        nameSi.isAcceptableOrUnknown(data['name_si']!, _nameSiMeta),
      );
    } else if (isInserting) {
      context.missing(_nameSiMeta);
    }
    if (data.containsKey('name_ta')) {
      context.handle(
        _nameTaMeta,
        nameTa.isAcceptableOrUnknown(data['name_ta']!, _nameTaMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTaMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('description_si')) {
      context.handle(
        _descriptionSiMeta,
        descriptionSi.isAcceptableOrUnknown(
          data['description_si']!,
          _descriptionSiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionSiMeta);
    }
    if (data.containsKey('description_ta')) {
      context.handle(
        _descriptionTaMeta,
        descriptionTa.isAcceptableOrUnknown(
          data['description_ta']!,
          _descriptionTaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionTaMeta);
    }
    if (data.containsKey('description_en')) {
      context.handle(
        _descriptionEnMeta,
        descriptionEn.isAcceptableOrUnknown(
          data['description_en']!,
          _descriptionEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionEnMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nameSi:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name_si'],
          )!,
      nameTa:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name_ta'],
          )!,
      nameEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name_en'],
          )!,
      descriptionSi:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description_si'],
          )!,
      descriptionTa:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description_ta'],
          )!,
      descriptionEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description_en'],
          )!,
      icon:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}icon'],
          )!,
      sortOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_order'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
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
  final DateTime createdAt;
  const Category({
    required this.id,
    required this.nameSi,
    required this.nameTa,
    required this.nameEn,
    required this.descriptionSi,
    required this.descriptionTa,
    required this.descriptionEn,
    required this.icon,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_si'] = Variable<String>(nameSi);
    map['name_ta'] = Variable<String>(nameTa);
    map['name_en'] = Variable<String>(nameEn);
    map['description_si'] = Variable<String>(descriptionSi);
    map['description_ta'] = Variable<String>(descriptionTa);
    map['description_en'] = Variable<String>(descriptionEn);
    map['icon'] = Variable<String>(icon);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      nameSi: Value(nameSi),
      nameTa: Value(nameTa),
      nameEn: Value(nameEn),
      descriptionSi: Value(descriptionSi),
      descriptionTa: Value(descriptionTa),
      descriptionEn: Value(descriptionEn),
      icon: Value(icon),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      nameSi: serializer.fromJson<String>(json['nameSi']),
      nameTa: serializer.fromJson<String>(json['nameTa']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      descriptionSi: serializer.fromJson<String>(json['descriptionSi']),
      descriptionTa: serializer.fromJson<String>(json['descriptionTa']),
      descriptionEn: serializer.fromJson<String>(json['descriptionEn']),
      icon: serializer.fromJson<String>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameSi': serializer.toJson<String>(nameSi),
      'nameTa': serializer.toJson<String>(nameTa),
      'nameEn': serializer.toJson<String>(nameEn),
      'descriptionSi': serializer.toJson<String>(descriptionSi),
      'descriptionTa': serializer.toJson<String>(descriptionTa),
      'descriptionEn': serializer.toJson<String>(descriptionEn),
      'icon': serializer.toJson<String>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith({
    int? id,
    String? nameSi,
    String? nameTa,
    String? nameEn,
    String? descriptionSi,
    String? descriptionTa,
    String? descriptionEn,
    String? icon,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
  }) => Category(
    id: id ?? this.id,
    nameSi: nameSi ?? this.nameSi,
    nameTa: nameTa ?? this.nameTa,
    nameEn: nameEn ?? this.nameEn,
    descriptionSi: descriptionSi ?? this.descriptionSi,
    descriptionTa: descriptionTa ?? this.descriptionTa,
    descriptionEn: descriptionEn ?? this.descriptionEn,
    icon: icon ?? this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      nameSi: data.nameSi.present ? data.nameSi.value : this.nameSi,
      nameTa: data.nameTa.present ? data.nameTa.value : this.nameTa,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      descriptionSi:
          data.descriptionSi.present
              ? data.descriptionSi.value
              : this.descriptionSi,
      descriptionTa:
          data.descriptionTa.present
              ? data.descriptionTa.value
              : this.descriptionTa,
      descriptionEn:
          data.descriptionEn.present
              ? data.descriptionEn.value
              : this.descriptionEn,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('nameSi: $nameSi, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn, ')
          ..write('descriptionSi: $descriptionSi, ')
          ..write('descriptionTa: $descriptionTa, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameSi,
    nameTa,
    nameEn,
    descriptionSi,
    descriptionTa,
    descriptionEn,
    icon,
    sortOrder,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.nameSi == this.nameSi &&
          other.nameTa == this.nameTa &&
          other.nameEn == this.nameEn &&
          other.descriptionSi == this.descriptionSi &&
          other.descriptionTa == this.descriptionTa &&
          other.descriptionEn == this.descriptionEn &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> nameSi;
  final Value<String> nameTa;
  final Value<String> nameEn;
  final Value<String> descriptionSi;
  final Value<String> descriptionTa;
  final Value<String> descriptionEn;
  final Value<String> icon;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.nameSi = const Value.absent(),
    this.nameTa = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.descriptionSi = const Value.absent(),
    this.descriptionTa = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nameSi,
    required String nameTa,
    required String nameEn,
    required String descriptionSi,
    required String descriptionTa,
    required String descriptionEn,
    required String icon,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nameSi = Value(nameSi),
       nameTa = Value(nameTa),
       nameEn = Value(nameEn),
       descriptionSi = Value(descriptionSi),
       descriptionTa = Value(descriptionTa),
       descriptionEn = Value(descriptionEn),
       icon = Value(icon);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? nameSi,
    Expression<String>? nameTa,
    Expression<String>? nameEn,
    Expression<String>? descriptionSi,
    Expression<String>? descriptionTa,
    Expression<String>? descriptionEn,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameSi != null) 'name_si': nameSi,
      if (nameTa != null) 'name_ta': nameTa,
      if (nameEn != null) 'name_en': nameEn,
      if (descriptionSi != null) 'description_si': descriptionSi,
      if (descriptionTa != null) 'description_ta': descriptionTa,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? nameSi,
    Value<String>? nameTa,
    Value<String>? nameEn,
    Value<String>? descriptionSi,
    Value<String>? descriptionTa,
    Value<String>? descriptionEn,
    Value<String>? icon,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      nameSi: nameSi ?? this.nameSi,
      nameTa: nameTa ?? this.nameTa,
      nameEn: nameEn ?? this.nameEn,
      descriptionSi: descriptionSi ?? this.descriptionSi,
      descriptionTa: descriptionTa ?? this.descriptionTa,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameSi.present) {
      map['name_si'] = Variable<String>(nameSi.value);
    }
    if (nameTa.present) {
      map['name_ta'] = Variable<String>(nameTa.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (descriptionSi.present) {
      map['description_si'] = Variable<String>(descriptionSi.value);
    }
    if (descriptionTa.present) {
      map['description_ta'] = Variable<String>(descriptionTa.value);
    }
    if (descriptionEn.present) {
      map['description_en'] = Variable<String>(descriptionEn.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameSi: $nameSi, ')
          ..write('nameTa: $nameTa, ')
          ..write('nameEn: $nameEn, ')
          ..write('descriptionSi: $descriptionSi, ')
          ..write('descriptionTa: $descriptionTa, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWordSiMeta = const VerificationMeta(
    'targetWordSi',
  );
  @override
  late final GeneratedColumn<String> targetWordSi = GeneratedColumn<String>(
    'target_word_si',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWordTaMeta = const VerificationMeta(
    'targetWordTa',
  );
  @override
  late final GeneratedColumn<String> targetWordTa = GeneratedColumn<String>(
    'target_word_ta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWordEnMeta = const VerificationMeta(
    'targetWordEn',
  );
  @override
  late final GeneratedColumn<String> targetWordEn = GeneratedColumn<String>(
    'target_word_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneticHintMeta = const VerificationMeta(
    'phoneticHint',
  );
  @override
  late final GeneratedColumn<String> phoneticHint = GeneratedColumn<String>(
    'phonetic_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    imagePath,
    targetWordSi,
    targetWordTa,
    targetWordEn,
    phoneticHint,
    difficulty,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('target_word_si')) {
      context.handle(
        _targetWordSiMeta,
        targetWordSi.isAcceptableOrUnknown(
          data['target_word_si']!,
          _targetWordSiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetWordSiMeta);
    }
    if (data.containsKey('target_word_ta')) {
      context.handle(
        _targetWordTaMeta,
        targetWordTa.isAcceptableOrUnknown(
          data['target_word_ta']!,
          _targetWordTaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetWordTaMeta);
    }
    if (data.containsKey('target_word_en')) {
      context.handle(
        _targetWordEnMeta,
        targetWordEn.isAcceptableOrUnknown(
          data['target_word_en']!,
          _targetWordEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetWordEnMeta);
    }
    if (data.containsKey('phonetic_hint')) {
      context.handle(
        _phoneticHintMeta,
        phoneticHint.isAcceptableOrUnknown(
          data['phonetic_hint']!,
          _phoneticHintMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      categoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}category_id'],
          )!,
      imagePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}image_path'],
          )!,
      targetWordSi:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}target_word_si'],
          )!,
      targetWordTa:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}target_word_ta'],
          )!,
      targetWordEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}target_word_en'],
          )!,
      phoneticHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phonetic_hint'],
      ),
      difficulty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}difficulty'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final int categoryId;
  final String imagePath;
  final String targetWordSi;
  final String targetWordTa;
  final String targetWordEn;
  final String? phoneticHint;
  final int difficulty;
  final bool isActive;
  final DateTime createdAt;
  const Exercise({
    required this.id,
    required this.categoryId,
    required this.imagePath,
    required this.targetWordSi,
    required this.targetWordTa,
    required this.targetWordEn,
    this.phoneticHint,
    required this.difficulty,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['image_path'] = Variable<String>(imagePath);
    map['target_word_si'] = Variable<String>(targetWordSi);
    map['target_word_ta'] = Variable<String>(targetWordTa);
    map['target_word_en'] = Variable<String>(targetWordEn);
    if (!nullToAbsent || phoneticHint != null) {
      map['phonetic_hint'] = Variable<String>(phoneticHint);
    }
    map['difficulty'] = Variable<int>(difficulty);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      imagePath: Value(imagePath),
      targetWordSi: Value(targetWordSi),
      targetWordTa: Value(targetWordTa),
      targetWordEn: Value(targetWordEn),
      phoneticHint:
          phoneticHint == null && nullToAbsent
              ? const Value.absent()
              : Value(phoneticHint),
      difficulty: Value(difficulty),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      targetWordSi: serializer.fromJson<String>(json['targetWordSi']),
      targetWordTa: serializer.fromJson<String>(json['targetWordTa']),
      targetWordEn: serializer.fromJson<String>(json['targetWordEn']),
      phoneticHint: serializer.fromJson<String?>(json['phoneticHint']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'imagePath': serializer.toJson<String>(imagePath),
      'targetWordSi': serializer.toJson<String>(targetWordSi),
      'targetWordTa': serializer.toJson<String>(targetWordTa),
      'targetWordEn': serializer.toJson<String>(targetWordEn),
      'phoneticHint': serializer.toJson<String?>(phoneticHint),
      'difficulty': serializer.toJson<int>(difficulty),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Exercise copyWith({
    int? id,
    int? categoryId,
    String? imagePath,
    String? targetWordSi,
    String? targetWordTa,
    String? targetWordEn,
    Value<String?> phoneticHint = const Value.absent(),
    int? difficulty,
    bool? isActive,
    DateTime? createdAt,
  }) => Exercise(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    imagePath: imagePath ?? this.imagePath,
    targetWordSi: targetWordSi ?? this.targetWordSi,
    targetWordTa: targetWordTa ?? this.targetWordTa,
    targetWordEn: targetWordEn ?? this.targetWordEn,
    phoneticHint: phoneticHint.present ? phoneticHint.value : this.phoneticHint,
    difficulty: difficulty ?? this.difficulty,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      targetWordSi:
          data.targetWordSi.present
              ? data.targetWordSi.value
              : this.targetWordSi,
      targetWordTa:
          data.targetWordTa.present
              ? data.targetWordTa.value
              : this.targetWordTa,
      targetWordEn:
          data.targetWordEn.present
              ? data.targetWordEn.value
              : this.targetWordEn,
      phoneticHint:
          data.phoneticHint.present
              ? data.phoneticHint.value
              : this.phoneticHint,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('targetWordSi: $targetWordSi, ')
          ..write('targetWordTa: $targetWordTa, ')
          ..write('targetWordEn: $targetWordEn, ')
          ..write('phoneticHint: $phoneticHint, ')
          ..write('difficulty: $difficulty, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    imagePath,
    targetWordSi,
    targetWordTa,
    targetWordEn,
    phoneticHint,
    difficulty,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.imagePath == this.imagePath &&
          other.targetWordSi == this.targetWordSi &&
          other.targetWordTa == this.targetWordTa &&
          other.targetWordEn == this.targetWordEn &&
          other.phoneticHint == this.phoneticHint &&
          other.difficulty == this.difficulty &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> imagePath;
  final Value<String> targetWordSi;
  final Value<String> targetWordTa;
  final Value<String> targetWordEn;
  final Value<String?> phoneticHint;
  final Value<int> difficulty;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.targetWordSi = const Value.absent(),
    this.targetWordTa = const Value.absent(),
    this.targetWordEn = const Value.absent(),
    this.phoneticHint = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String imagePath,
    required String targetWordSi,
    required String targetWordTa,
    required String targetWordEn,
    this.phoneticHint = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : categoryId = Value(categoryId),
       imagePath = Value(imagePath),
       targetWordSi = Value(targetWordSi),
       targetWordTa = Value(targetWordTa),
       targetWordEn = Value(targetWordEn);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? imagePath,
    Expression<String>? targetWordSi,
    Expression<String>? targetWordTa,
    Expression<String>? targetWordEn,
    Expression<String>? phoneticHint,
    Expression<int>? difficulty,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (imagePath != null) 'image_path': imagePath,
      if (targetWordSi != null) 'target_word_si': targetWordSi,
      if (targetWordTa != null) 'target_word_ta': targetWordTa,
      if (targetWordEn != null) 'target_word_en': targetWordEn,
      if (phoneticHint != null) 'phonetic_hint': phoneticHint,
      if (difficulty != null) 'difficulty': difficulty,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryId,
    Value<String>? imagePath,
    Value<String>? targetWordSi,
    Value<String>? targetWordTa,
    Value<String>? targetWordEn,
    Value<String?>? phoneticHint,
    Value<int>? difficulty,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      imagePath: imagePath ?? this.imagePath,
      targetWordSi: targetWordSi ?? this.targetWordSi,
      targetWordTa: targetWordTa ?? this.targetWordTa,
      targetWordEn: targetWordEn ?? this.targetWordEn,
      phoneticHint: phoneticHint ?? this.phoneticHint,
      difficulty: difficulty ?? this.difficulty,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (targetWordSi.present) {
      map['target_word_si'] = Variable<String>(targetWordSi.value);
    }
    if (targetWordTa.present) {
      map['target_word_ta'] = Variable<String>(targetWordTa.value);
    }
    if (targetWordEn.present) {
      map['target_word_en'] = Variable<String>(targetWordEn.value);
    }
    if (phoneticHint.present) {
      map['phonetic_hint'] = Variable<String>(phoneticHint.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('targetWordSi: $targetWordSi, ')
          ..write('targetWordTa: $targetWordTa, ')
          ..write('targetWordEn: $targetWordEn, ')
          ..write('phoneticHint: $phoneticHint, ')
          ..write('difficulty: $difficulty, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalExercisesMeta = const VerificationMeta(
    'totalExercises',
  );
  @override
  late final GeneratedColumn<int> totalExercises = GeneratedColumn<int>(
    'total_exercises',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedExercisesMeta =
      const VerificationMeta('completedExercises');
  @override
  late final GeneratedColumn<int> completedExercises = GeneratedColumn<int>(
    'completed_exercises',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _averageScoreMeta = const VerificationMeta(
    'averageScore',
  );
  @override
  late final GeneratedColumn<double> averageScore = GeneratedColumn<double>(
    'average_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    completedAt,
    type,
    totalExercises,
    completedExercises,
    averageScore,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('total_exercises')) {
      context.handle(
        _totalExercisesMeta,
        totalExercises.isAcceptableOrUnknown(
          data['total_exercises']!,
          _totalExercisesMeta,
        ),
      );
    }
    if (data.containsKey('completed_exercises')) {
      context.handle(
        _completedExercisesMeta,
        completedExercises.isAcceptableOrUnknown(
          data['completed_exercises']!,
          _completedExercisesMeta,
        ),
      );
    }
    if (data.containsKey('average_score')) {
      context.handle(
        _averageScoreMeta,
        averageScore.isAcceptableOrUnknown(
          data['average_score']!,
          _averageScoreMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      totalExercises:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_exercises'],
          )!,
      completedExercises:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}completed_exercises'],
          )!,
      averageScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_score'],
      ),
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String type;
  final int totalExercises;
  final int completedExercises;
  final double? averageScore;
  final bool isSynced;
  final DateTime createdAt;
  const Session({
    required this.id,
    required this.startedAt,
    this.completedAt,
    required this.type,
    required this.totalExercises,
    required this.completedExercises,
    this.averageScore,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['type'] = Variable<String>(type);
    map['total_exercises'] = Variable<int>(totalExercises);
    map['completed_exercises'] = Variable<int>(completedExercises);
    if (!nullToAbsent || averageScore != null) {
      map['average_score'] = Variable<double>(averageScore);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      completedAt:
          completedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(completedAt),
      type: Value(type),
      totalExercises: Value(totalExercises),
      completedExercises: Value(completedExercises),
      averageScore:
          averageScore == null && nullToAbsent
              ? const Value.absent()
              : Value(averageScore),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      type: serializer.fromJson<String>(json['type']),
      totalExercises: serializer.fromJson<int>(json['totalExercises']),
      completedExercises: serializer.fromJson<int>(json['completedExercises']),
      averageScore: serializer.fromJson<double?>(json['averageScore']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'type': serializer.toJson<String>(type),
      'totalExercises': serializer.toJson<int>(totalExercises),
      'completedExercises': serializer.toJson<int>(completedExercises),
      'averageScore': serializer.toJson<double?>(averageScore),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Session copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    String? type,
    int? totalExercises,
    int? completedExercises,
    Value<double?> averageScore = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
  }) => Session(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    type: type ?? this.type,
    totalExercises: totalExercises ?? this.totalExercises,
    completedExercises: completedExercises ?? this.completedExercises,
    averageScore: averageScore.present ? averageScore.value : this.averageScore,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      type: data.type.present ? data.type.value : this.type,
      totalExercises:
          data.totalExercises.present
              ? data.totalExercises.value
              : this.totalExercises,
      completedExercises:
          data.completedExercises.present
              ? data.completedExercises.value
              : this.completedExercises,
      averageScore:
          data.averageScore.present
              ? data.averageScore.value
              : this.averageScore,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('type: $type, ')
          ..write('totalExercises: $totalExercises, ')
          ..write('completedExercises: $completedExercises, ')
          ..write('averageScore: $averageScore, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    completedAt,
    type,
    totalExercises,
    completedExercises,
    averageScore,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.type == this.type &&
          other.totalExercises == this.totalExercises &&
          other.completedExercises == this.completedExercises &&
          other.averageScore == this.averageScore &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String> type;
  final Value<int> totalExercises;
  final Value<int> completedExercises;
  final Value<double?> averageScore;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.type = const Value.absent(),
    this.totalExercises = const Value.absent(),
    this.completedExercises = const Value.absent(),
    this.averageScore = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required String type,
    this.totalExercises = const Value.absent(),
    this.completedExercises = const Value.absent(),
    this.averageScore = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : type = Value(type);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? type,
    Expression<int>? totalExercises,
    Expression<int>? completedExercises,
    Expression<double>? averageScore,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (type != null) 'type': type,
      if (totalExercises != null) 'total_exercises': totalExercises,
      if (completedExercises != null) 'completed_exercises': completedExercises,
      if (averageScore != null) 'average_score': averageScore,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String>? type,
    Value<int>? totalExercises,
    Value<int>? completedExercises,
    Value<double?>? averageScore,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      type: type ?? this.type,
      totalExercises: totalExercises ?? this.totalExercises,
      completedExercises: completedExercises ?? this.completedExercises,
      averageScore: averageScore ?? this.averageScore,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (totalExercises.present) {
      map['total_exercises'] = Variable<int>(totalExercises.value);
    }
    if (completedExercises.present) {
      map['completed_exercises'] = Variable<int>(completedExercises.value);
    }
    if (averageScore.present) {
      map['average_score'] = Variable<double>(averageScore.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('type: $type, ')
          ..write('totalExercises: $totalExercises, ')
          ..write('completedExercises: $completedExercises, ')
          ..write('averageScore: $averageScore, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AttemptsTable extends Attempts with TableInfo<$AttemptsTable, Attempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _userResponseMeta = const VerificationMeta(
    'userResponse',
  );
  @override
  late final GeneratedColumn<String> userResponse = GeneratedColumn<String>(
    'user_response',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedAnswerMeta = const VerificationMeta(
    'expectedAnswer',
  );
  @override
  late final GeneratedColumn<String> expectedAnswer = GeneratedColumn<String>(
    'expected_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scorePercentageMeta = const VerificationMeta(
    'scorePercentage',
  );
  @override
  late final GeneratedColumn<double> scorePercentage = GeneratedColumn<double>(
    'score_percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreLevelMeta = const VerificationMeta(
    'scoreLevel',
  );
  @override
  late final GeneratedColumn<String> scoreLevel = GeneratedColumn<String>(
    'score_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseTimeMsMeta = const VerificationMeta(
    'responseTimeMs',
  );
  @override
  late final GeneratedColumn<int> responseTimeMs = GeneratedColumn<int>(
    'response_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOfflineMeta = const VerificationMeta(
    'isOffline',
  );
  @override
  late final GeneratedColumn<bool> isOffline = GeneratedColumn<bool>(
    'is_offline',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_offline" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    userResponse,
    expectedAnswer,
    scorePercentage,
    scoreLevel,
    responseTimeMs,
    isOffline,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    }
    if (data.containsKey('user_response')) {
      context.handle(
        _userResponseMeta,
        userResponse.isAcceptableOrUnknown(
          data['user_response']!,
          _userResponseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userResponseMeta);
    }
    if (data.containsKey('expected_answer')) {
      context.handle(
        _expectedAnswerMeta,
        expectedAnswer.isAcceptableOrUnknown(
          data['expected_answer']!,
          _expectedAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedAnswerMeta);
    }
    if (data.containsKey('score_percentage')) {
      context.handle(
        _scorePercentageMeta,
        scorePercentage.isAcceptableOrUnknown(
          data['score_percentage']!,
          _scorePercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scorePercentageMeta);
    }
    if (data.containsKey('score_level')) {
      context.handle(
        _scoreLevelMeta,
        scoreLevel.isAcceptableOrUnknown(data['score_level']!, _scoreLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreLevelMeta);
    }
    if (data.containsKey('response_time_ms')) {
      context.handle(
        _responseTimeMsMeta,
        responseTimeMs.isAcceptableOrUnknown(
          data['response_time_ms']!,
          _responseTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('is_offline')) {
      context.handle(
        _isOfflineMeta,
        isOffline.isAcceptableOrUnknown(data['is_offline']!, _isOfflineMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attempt(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}session_id'],
          )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      ),
      userResponse:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_response'],
          )!,
      expectedAnswer:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}expected_answer'],
          )!,
      scorePercentage:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}score_percentage'],
          )!,
      scoreLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}score_level'],
          )!,
      responseTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_time_ms'],
      ),
      isOffline:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_offline'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $AttemptsTable createAlias(String alias) {
    return $AttemptsTable(attachedDatabase, alias);
  }
}

class Attempt extends DataClass implements Insertable<Attempt> {
  final int id;
  final int sessionId;
  final int? exerciseId;
  final String userResponse;
  final String expectedAnswer;
  final double scorePercentage;
  final String scoreLevel;
  final int? responseTimeMs;
  final bool isOffline;
  final bool isSynced;
  final DateTime createdAt;
  const Attempt({
    required this.id,
    required this.sessionId,
    this.exerciseId,
    required this.userResponse,
    required this.expectedAnswer,
    required this.scorePercentage,
    required this.scoreLevel,
    this.responseTimeMs,
    required this.isOffline,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    if (!nullToAbsent || exerciseId != null) {
      map['exercise_id'] = Variable<int>(exerciseId);
    }
    map['user_response'] = Variable<String>(userResponse);
    map['expected_answer'] = Variable<String>(expectedAnswer);
    map['score_percentage'] = Variable<double>(scorePercentage);
    map['score_level'] = Variable<String>(scoreLevel);
    if (!nullToAbsent || responseTimeMs != null) {
      map['response_time_ms'] = Variable<int>(responseTimeMs);
    }
    map['is_offline'] = Variable<bool>(isOffline);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttemptsCompanion toCompanion(bool nullToAbsent) {
    return AttemptsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId:
          exerciseId == null && nullToAbsent
              ? const Value.absent()
              : Value(exerciseId),
      userResponse: Value(userResponse),
      expectedAnswer: Value(expectedAnswer),
      scorePercentage: Value(scorePercentage),
      scoreLevel: Value(scoreLevel),
      responseTimeMs:
          responseTimeMs == null && nullToAbsent
              ? const Value.absent()
              : Value(responseTimeMs),
      isOffline: Value(isOffline),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory Attempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attempt(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<int?>(json['exerciseId']),
      userResponse: serializer.fromJson<String>(json['userResponse']),
      expectedAnswer: serializer.fromJson<String>(json['expectedAnswer']),
      scorePercentage: serializer.fromJson<double>(json['scorePercentage']),
      scoreLevel: serializer.fromJson<String>(json['scoreLevel']),
      responseTimeMs: serializer.fromJson<int?>(json['responseTimeMs']),
      isOffline: serializer.fromJson<bool>(json['isOffline']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<int?>(exerciseId),
      'userResponse': serializer.toJson<String>(userResponse),
      'expectedAnswer': serializer.toJson<String>(expectedAnswer),
      'scorePercentage': serializer.toJson<double>(scorePercentage),
      'scoreLevel': serializer.toJson<String>(scoreLevel),
      'responseTimeMs': serializer.toJson<int?>(responseTimeMs),
      'isOffline': serializer.toJson<bool>(isOffline),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attempt copyWith({
    int? id,
    int? sessionId,
    Value<int?> exerciseId = const Value.absent(),
    String? userResponse,
    String? expectedAnswer,
    double? scorePercentage,
    String? scoreLevel,
    Value<int?> responseTimeMs = const Value.absent(),
    bool? isOffline,
    bool? isSynced,
    DateTime? createdAt,
  }) => Attempt(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId.present ? exerciseId.value : this.exerciseId,
    userResponse: userResponse ?? this.userResponse,
    expectedAnswer: expectedAnswer ?? this.expectedAnswer,
    scorePercentage: scorePercentage ?? this.scorePercentage,
    scoreLevel: scoreLevel ?? this.scoreLevel,
    responseTimeMs:
        responseTimeMs.present ? responseTimeMs.value : this.responseTimeMs,
    isOffline: isOffline ?? this.isOffline,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  Attempt copyWithCompanion(AttemptsCompanion data) {
    return Attempt(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      userResponse:
          data.userResponse.present
              ? data.userResponse.value
              : this.userResponse,
      expectedAnswer:
          data.expectedAnswer.present
              ? data.expectedAnswer.value
              : this.expectedAnswer,
      scorePercentage:
          data.scorePercentage.present
              ? data.scorePercentage.value
              : this.scorePercentage,
      scoreLevel:
          data.scoreLevel.present ? data.scoreLevel.value : this.scoreLevel,
      responseTimeMs:
          data.responseTimeMs.present
              ? data.responseTimeMs.value
              : this.responseTimeMs,
      isOffline: data.isOffline.present ? data.isOffline.value : this.isOffline,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attempt(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('userResponse: $userResponse, ')
          ..write('expectedAnswer: $expectedAnswer, ')
          ..write('scorePercentage: $scorePercentage, ')
          ..write('scoreLevel: $scoreLevel, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('isOffline: $isOffline, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    userResponse,
    expectedAnswer,
    scorePercentage,
    scoreLevel,
    responseTimeMs,
    isOffline,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attempt &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.userResponse == this.userResponse &&
          other.expectedAnswer == this.expectedAnswer &&
          other.scorePercentage == this.scorePercentage &&
          other.scoreLevel == this.scoreLevel &&
          other.responseTimeMs == this.responseTimeMs &&
          other.isOffline == this.isOffline &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class AttemptsCompanion extends UpdateCompanion<Attempt> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int?> exerciseId;
  final Value<String> userResponse;
  final Value<String> expectedAnswer;
  final Value<double> scorePercentage;
  final Value<String> scoreLevel;
  final Value<int?> responseTimeMs;
  final Value<bool> isOffline;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  const AttemptsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.userResponse = const Value.absent(),
    this.expectedAnswer = const Value.absent(),
    this.scorePercentage = const Value.absent(),
    this.scoreLevel = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.isOffline = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttemptsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    this.exerciseId = const Value.absent(),
    required String userResponse,
    required String expectedAnswer,
    required double scorePercentage,
    required String scoreLevel,
    this.responseTimeMs = const Value.absent(),
    this.isOffline = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       userResponse = Value(userResponse),
       expectedAnswer = Value(expectedAnswer),
       scorePercentage = Value(scorePercentage),
       scoreLevel = Value(scoreLevel);
  static Insertable<Attempt> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? exerciseId,
    Expression<String>? userResponse,
    Expression<String>? expectedAnswer,
    Expression<double>? scorePercentage,
    Expression<String>? scoreLevel,
    Expression<int>? responseTimeMs,
    Expression<bool>? isOffline,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (userResponse != null) 'user_response': userResponse,
      if (expectedAnswer != null) 'expected_answer': expectedAnswer,
      if (scorePercentage != null) 'score_percentage': scorePercentage,
      if (scoreLevel != null) 'score_level': scoreLevel,
      if (responseTimeMs != null) 'response_time_ms': responseTimeMs,
      if (isOffline != null) 'is_offline': isOffline,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttemptsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int?>? exerciseId,
    Value<String>? userResponse,
    Value<String>? expectedAnswer,
    Value<double>? scorePercentage,
    Value<String>? scoreLevel,
    Value<int?>? responseTimeMs,
    Value<bool>? isOffline,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
  }) {
    return AttemptsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      userResponse: userResponse ?? this.userResponse,
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
      scorePercentage: scorePercentage ?? this.scorePercentage,
      scoreLevel: scoreLevel ?? this.scoreLevel,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      isOffline: isOffline ?? this.isOffline,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (userResponse.present) {
      map['user_response'] = Variable<String>(userResponse.value);
    }
    if (expectedAnswer.present) {
      map['expected_answer'] = Variable<String>(expectedAnswer.value);
    }
    if (scorePercentage.present) {
      map['score_percentage'] = Variable<double>(scorePercentage.value);
    }
    if (scoreLevel.present) {
      map['score_level'] = Variable<String>(scoreLevel.value);
    }
    if (responseTimeMs.present) {
      map['response_time_ms'] = Variable<int>(responseTimeMs.value);
    }
    if (isOffline.present) {
      map['is_offline'] = Variable<bool>(isOffline.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('userResponse: $userResponse, ')
          ..write('expectedAnswer: $expectedAnswer, ')
          ..write('scorePercentage: $scorePercentage, ')
          ..write('scoreLevel: $scoreLevel, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('isOffline: $isOffline, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LiveConversationsTable extends LiveConversations
    with TableInfo<$LiveConversationsTable, LiveConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiveConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userTranscriptMeta = const VerificationMeta(
    'userTranscript',
  );
  @override
  late final GeneratedColumn<String> userTranscript = GeneratedColumn<String>(
    'user_transcript',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aiFeedbackMeta = const VerificationMeta(
    'aiFeedback',
  );
  @override
  late final GeneratedColumn<String> aiFeedback = GeneratedColumn<String>(
    'ai_feedback',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseType,
    durationSeconds,
    userTranscript,
    aiFeedback,
    score,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'live_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LiveConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseTypeMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('user_transcript')) {
      context.handle(
        _userTranscriptMeta,
        userTranscript.isAcceptableOrUnknown(
          data['user_transcript']!,
          _userTranscriptMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userTranscriptMeta);
    }
    if (data.containsKey('ai_feedback')) {
      context.handle(
        _aiFeedbackMeta,
        aiFeedback.isAcceptableOrUnknown(data['ai_feedback']!, _aiFeedbackMeta),
      );
    } else if (isInserting) {
      context.missing(_aiFeedbackMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LiveConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LiveConversation(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}session_id'],
          )!,
      exerciseType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}exercise_type'],
          )!,
      durationSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration_seconds'],
          )!,
      userTranscript:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_transcript'],
          )!,
      aiFeedback:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ai_feedback'],
          )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $LiveConversationsTable createAlias(String alias) {
    return $LiveConversationsTable(attachedDatabase, alias);
  }
}

class LiveConversation extends DataClass
    implements Insertable<LiveConversation> {
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
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_type'] = Variable<String>(exerciseType);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['user_transcript'] = Variable<String>(userTranscript);
    map['ai_feedback'] = Variable<String>(aiFeedback);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LiveConversationsCompanion toCompanion(bool nullToAbsent) {
    return LiveConversationsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseType: Value(exerciseType),
      durationSeconds: Value(durationSeconds),
      userTranscript: Value(userTranscript),
      aiFeedback: Value(aiFeedback),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory LiveConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LiveConversation(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      userTranscript: serializer.fromJson<String>(json['userTranscript']),
      aiFeedback: serializer.fromJson<String>(json['aiFeedback']),
      score: serializer.fromJson<double?>(json['score']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseType': serializer.toJson<String>(exerciseType),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'userTranscript': serializer.toJson<String>(userTranscript),
      'aiFeedback': serializer.toJson<String>(aiFeedback),
      'score': serializer.toJson<double?>(score),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LiveConversation copyWith({
    int? id,
    int? sessionId,
    String? exerciseType,
    int? durationSeconds,
    String? userTranscript,
    String? aiFeedback,
    Value<double?> score = const Value.absent(),
    bool? isSynced,
    DateTime? createdAt,
  }) => LiveConversation(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseType: exerciseType ?? this.exerciseType,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    userTranscript: userTranscript ?? this.userTranscript,
    aiFeedback: aiFeedback ?? this.aiFeedback,
    score: score.present ? score.value : this.score,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  LiveConversation copyWithCompanion(LiveConversationsCompanion data) {
    return LiveConversation(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseType:
          data.exerciseType.present
              ? data.exerciseType.value
              : this.exerciseType,
      durationSeconds:
          data.durationSeconds.present
              ? data.durationSeconds.value
              : this.durationSeconds,
      userTranscript:
          data.userTranscript.present
              ? data.userTranscript.value
              : this.userTranscript,
      aiFeedback:
          data.aiFeedback.present ? data.aiFeedback.value : this.aiFeedback,
      score: data.score.present ? data.score.value : this.score,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LiveConversation(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('userTranscript: $userTranscript, ')
          ..write('aiFeedback: $aiFeedback, ')
          ..write('score: $score, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseType,
    durationSeconds,
    userTranscript,
    aiFeedback,
    score,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiveConversation &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseType == this.exerciseType &&
          other.durationSeconds == this.durationSeconds &&
          other.userTranscript == this.userTranscript &&
          other.aiFeedback == this.aiFeedback &&
          other.score == this.score &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class LiveConversationsCompanion extends UpdateCompanion<LiveConversation> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> exerciseType;
  final Value<int> durationSeconds;
  final Value<String> userTranscript;
  final Value<String> aiFeedback;
  final Value<double?> score;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  const LiveConversationsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.userTranscript = const Value.absent(),
    this.aiFeedback = const Value.absent(),
    this.score = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LiveConversationsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String exerciseType,
    required int durationSeconds,
    required String userTranscript,
    required String aiFeedback,
    this.score = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exerciseType = Value(exerciseType),
       durationSeconds = Value(durationSeconds),
       userTranscript = Value(userTranscript),
       aiFeedback = Value(aiFeedback);
  static Insertable<LiveConversation> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? exerciseType,
    Expression<int>? durationSeconds,
    Expression<String>? userTranscript,
    Expression<String>? aiFeedback,
    Expression<double>? score,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (userTranscript != null) 'user_transcript': userTranscript,
      if (aiFeedback != null) 'ai_feedback': aiFeedback,
      if (score != null) 'score': score,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LiveConversationsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? exerciseType,
    Value<int>? durationSeconds,
    Value<String>? userTranscript,
    Value<String>? aiFeedback,
    Value<double?>? score,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
  }) {
    return LiveConversationsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseType: exerciseType ?? this.exerciseType,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      userTranscript: userTranscript ?? this.userTranscript,
      aiFeedback: aiFeedback ?? this.aiFeedback,
      score: score ?? this.score,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (userTranscript.present) {
      map['user_transcript'] = Variable<String>(userTranscript.value);
    }
    if (aiFeedback.present) {
      map['ai_feedback'] = Variable<String>(aiFeedback.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiveConversationsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('userTranscript: $userTranscript, ')
          ..write('aiFeedback: $aiFeedback, ')
          ..write('score: $score, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncLogTable extends SyncLog with TableInfo<$SyncLogTable, SyncLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    recordId,
    action,
    syncedAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLogData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      entityType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entity_type'],
          )!,
      recordId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}record_id'],
          )!,
      action:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}action'],
          )!,
      syncedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}synced_at'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
    );
  }

  @override
  $SyncLogTable createAlias(String alias) {
    return $SyncLogTable(attachedDatabase, alias);
  }
}

class SyncLogData extends DataClass implements Insertable<SyncLogData> {
  final int id;
  final String entityType;
  final int recordId;
  final String action;
  final DateTime syncedAt;
  final String status;
  const SyncLogData({
    required this.id,
    required this.entityType,
    required this.recordId,
    required this.action,
    required this.syncedAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['record_id'] = Variable<int>(recordId);
    map['action'] = Variable<String>(action);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    map['status'] = Variable<String>(status);
    return map;
  }

  SyncLogCompanion toCompanion(bool nullToAbsent) {
    return SyncLogCompanion(
      id: Value(id),
      entityType: Value(entityType),
      recordId: Value(recordId),
      action: Value(action),
      syncedAt: Value(syncedAt),
      status: Value(status),
    );
  }

  factory SyncLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLogData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      recordId: serializer.fromJson<int>(json['recordId']),
      action: serializer.fromJson<String>(json['action']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'recordId': serializer.toJson<int>(recordId),
      'action': serializer.toJson<String>(action),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncLogData copyWith({
    int? id,
    String? entityType,
    int? recordId,
    String? action,
    DateTime? syncedAt,
    String? status,
  }) => SyncLogData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    recordId: recordId ?? this.recordId,
    action: action ?? this.action,
    syncedAt: syncedAt ?? this.syncedAt,
    status: status ?? this.status,
  );
  SyncLogData copyWithCompanion(SyncLogCompanion data) {
    return SyncLogData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      action: data.action.present ? data.action.value : this.action,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('recordId: $recordId, ')
          ..write('action: $action, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, recordId, action, syncedAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLogData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.recordId == this.recordId &&
          other.action == this.action &&
          other.syncedAt == this.syncedAt &&
          other.status == this.status);
}

class SyncLogCompanion extends UpdateCompanion<SyncLogData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> recordId;
  final Value<String> action;
  final Value<DateTime> syncedAt;
  final Value<String> status;
  const SyncLogCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.recordId = const Value.absent(),
    this.action = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  SyncLogCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int recordId,
    required String action,
    this.syncedAt = const Value.absent(),
    this.status = const Value.absent(),
  }) : entityType = Value(entityType),
       recordId = Value(recordId),
       action = Value(action);
  static Insertable<SyncLogData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? recordId,
    Expression<String>? action,
    Expression<DateTime>? syncedAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (recordId != null) 'record_id': recordId,
      if (action != null) 'action': action,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (status != null) 'status': status,
    });
  }

  SyncLogCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<int>? recordId,
    Value<String>? action,
    Value<DateTime>? syncedAt,
    Value<String>? status,
  }) {
    return SyncLogCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      recordId: recordId ?? this.recordId,
      action: action ?? this.action,
      syncedAt: syncedAt ?? this.syncedAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('recordId: $recordId, ')
          ..write('action: $action, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$HandaDatabase extends GeneratedDatabase {
  _$HandaDatabase(QueryExecutor e) : super(e);
  $HandaDatabaseManager get managers => $HandaDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $AttemptsTable attempts = $AttemptsTable(this);
  late final $LiveConversationsTable liveConversations =
      $LiveConversationsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SyncLogTable syncLog = $SyncLogTable(this);
  late final CategoryDao categoryDao = CategoryDao(this as HandaDatabase);
  late final ExerciseDao exerciseDao = ExerciseDao(this as HandaDatabase);
  late final SessionDao sessionDao = SessionDao(this as HandaDatabase);
  late final AttemptDao attemptDao = AttemptDao(this as HandaDatabase);
  late final LiveConversationDao liveConversationDao = LiveConversationDao(
    this as HandaDatabase,
  );
  late final SettingsDao settingsDao = SettingsDao(this as HandaDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    exercises,
    sessions,
    attempts,
    liveConversations,
    appSettings,
    syncLog,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String nameSi,
      required String nameTa,
      required String nameEn,
      required String descriptionSi,
      required String descriptionTa,
      required String descriptionEn,
      required String icon,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> nameSi,
      Value<String> nameTa,
      Value<String> nameEn,
      Value<String> descriptionSi,
      Value<String> descriptionTa,
      Value<String> descriptionEn,
      Value<String> icon,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$HandaDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExercisesTable, List<Exercise>>
  _exercisesRefsTable(_$HandaDatabase db) => MultiTypedResultKey.fromTable(
    db.exercises,
    aliasName: $_aliasNameGenerator(db.categories.id, db.exercises.categoryId),
  );

  $$ExercisesTableProcessedTableManager get exercisesRefs {
    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$HandaDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameSi => $composableBuilder(
    column: $table.nameSi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionSi => $composableBuilder(
    column: $table.descriptionSi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionTa => $composableBuilder(
    column: $table.descriptionTa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exercisesRefs(
    Expression<bool> Function($$ExercisesTableFilterComposer f) f,
  ) {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$HandaDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameSi => $composableBuilder(
    column: $table.nameSi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTa => $composableBuilder(
    column: $table.nameTa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionSi => $composableBuilder(
    column: $table.descriptionSi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionTa => $composableBuilder(
    column: $table.descriptionTa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$HandaDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameSi =>
      $composableBuilder(column: $table.nameSi, builder: (column) => column);

  GeneratedColumn<String> get nameTa =>
      $composableBuilder(column: $table.nameTa, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get descriptionSi => $composableBuilder(
    column: $table.descriptionSi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionTa => $composableBuilder(
    column: $table.descriptionTa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> exercisesRefs<T extends Object>(
    Expression<T> Function($$ExercisesTableAnnotationComposer a) f,
  ) {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$HandaDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool exercisesRefs})
        > {
  $$CategoriesTableTableManager(_$HandaDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameSi = const Value.absent(),
                Value<String> nameTa = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> descriptionSi = const Value.absent(),
                Value<String> descriptionTa = const Value.absent(),
                Value<String> descriptionEn = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                nameSi: nameSi,
                nameTa: nameTa,
                nameEn: nameEn,
                descriptionSi: descriptionSi,
                descriptionTa: descriptionTa,
                descriptionEn: descriptionEn,
                icon: icon,
                sortOrder: sortOrder,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameSi,
                required String nameTa,
                required String nameEn,
                required String descriptionSi,
                required String descriptionTa,
                required String descriptionEn,
                required String icon,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                nameSi: nameSi,
                nameTa: nameTa,
                nameEn: nameEn,
                descriptionSi: descriptionSi,
                descriptionTa: descriptionTa,
                descriptionEn: descriptionEn,
                icon: icon,
                sortOrder: sortOrder,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CategoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({exercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exercisesRefs) db.exercises],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exercisesRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      Exercise
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._exercisesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).exercisesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.categoryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$HandaDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool exercisesRefs})
    >;
typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      required int categoryId,
      required String imagePath,
      required String targetWordSi,
      required String targetWordTa,
      required String targetWordEn,
      Value<String?> phoneticHint,
      Value<int> difficulty,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<int> categoryId,
      Value<String> imagePath,
      Value<String> targetWordSi,
      Value<String> targetWordTa,
      Value<String> targetWordEn,
      Value<String?> phoneticHint,
      Value<int> difficulty,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$HandaDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$HandaDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.exercises.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AttemptsTable, List<Attempt>> _attemptsRefsTable(
    _$HandaDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.attempts,
    aliasName: $_aliasNameGenerator(db.exercises.id, db.attempts.exerciseId),
  );

  $$AttemptsTableProcessedTableManager get attemptsRefs {
    final manager = $$AttemptsTableTableManager(
      $_db,
      $_db.attempts,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$HandaDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetWordSi => $composableBuilder(
    column: $table.targetWordSi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetWordTa => $composableBuilder(
    column: $table.targetWordTa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetWordEn => $composableBuilder(
    column: $table.targetWordEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneticHint => $composableBuilder(
    column: $table.phoneticHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> attemptsRefs(
    Expression<bool> Function($$AttemptsTableFilterComposer f) f,
  ) {
    final $$AttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attempts,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptsTableFilterComposer(
            $db: $db,
            $table: $db.attempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$HandaDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetWordSi => $composableBuilder(
    column: $table.targetWordSi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetWordTa => $composableBuilder(
    column: $table.targetWordTa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetWordEn => $composableBuilder(
    column: $table.targetWordEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneticHint => $composableBuilder(
    column: $table.phoneticHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$HandaDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get targetWordSi => $composableBuilder(
    column: $table.targetWordSi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetWordTa => $composableBuilder(
    column: $table.targetWordTa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetWordEn => $composableBuilder(
    column: $table.targetWordEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneticHint => $composableBuilder(
    column: $table.phoneticHint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> attemptsRefs<T extends Object>(
    Expression<T> Function($$AttemptsTableAnnotationComposer a) f,
  ) {
    final $$AttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attempts,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.attempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$HandaDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool categoryId, bool attemptsRefs})
        > {
  $$ExercisesTableTableManager(_$HandaDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> targetWordSi = const Value.absent(),
                Value<String> targetWordTa = const Value.absent(),
                Value<String> targetWordEn = const Value.absent(),
                Value<String?> phoneticHint = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                categoryId: categoryId,
                imagePath: imagePath,
                targetWordSi: targetWordSi,
                targetWordTa: targetWordTa,
                targetWordEn: targetWordEn,
                phoneticHint: phoneticHint,
                difficulty: difficulty,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryId,
                required String imagePath,
                required String targetWordSi,
                required String targetWordTa,
                required String targetWordEn,
                Value<String?> phoneticHint = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                categoryId: categoryId,
                imagePath: imagePath,
                targetWordSi: targetWordSi,
                targetWordTa: targetWordTa,
                targetWordEn: targetWordEn,
                phoneticHint: phoneticHint,
                difficulty: difficulty,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExercisesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({categoryId = false, attemptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attemptsRefs) db.attempts],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (categoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ExercisesTableReferences
                                ._categoryIdTable(db),
                            referencedColumn:
                                $$ExercisesTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attemptsRefs)
                    await $_getPrefetchedData<
                      Exercise,
                      $ExercisesTable,
                      Attempt
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._attemptsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).attemptsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.exerciseId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$HandaDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool categoryId, bool attemptsRefs})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      required String type,
      Value<int> totalExercises,
      Value<int> completedExercises,
      Value<double?> averageScore,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<String> type,
      Value<int> totalExercises,
      Value<int> completedExercises,
      Value<double?> averageScore,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$HandaDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttemptsTable, List<Attempt>> _attemptsRefsTable(
    _$HandaDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.attempts,
    aliasName: $_aliasNameGenerator(db.sessions.id, db.attempts.sessionId),
  );

  $$AttemptsTableProcessedTableManager get attemptsRefs {
    final manager = $$AttemptsTableTableManager(
      $_db,
      $_db.attempts,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LiveConversationsTable, List<LiveConversation>>
  _liveConversationsRefsTable(_$HandaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.liveConversations,
        aliasName: $_aliasNameGenerator(
          db.sessions.id,
          db.liveConversations.sessionId,
        ),
      );

  $$LiveConversationsTableProcessedTableManager get liveConversationsRefs {
    final manager = $$LiveConversationsTableTableManager(
      $_db,
      $_db.liveConversations,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _liveConversationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$HandaDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalExercises => $composableBuilder(
    column: $table.totalExercises,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedExercises => $composableBuilder(
    column: $table.completedExercises,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageScore => $composableBuilder(
    column: $table.averageScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> attemptsRefs(
    Expression<bool> Function($$AttemptsTableFilterComposer f) f,
  ) {
    final $$AttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attempts,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptsTableFilterComposer(
            $db: $db,
            $table: $db.attempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> liveConversationsRefs(
    Expression<bool> Function($$LiveConversationsTableFilterComposer f) f,
  ) {
    final $$LiveConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.liveConversations,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LiveConversationsTableFilterComposer(
            $db: $db,
            $table: $db.liveConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$HandaDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalExercises => $composableBuilder(
    column: $table.totalExercises,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedExercises => $composableBuilder(
    column: $table.completedExercises,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageScore => $composableBuilder(
    column: $table.averageScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$HandaDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get totalExercises => $composableBuilder(
    column: $table.totalExercises,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedExercises => $composableBuilder(
    column: $table.completedExercises,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageScore => $composableBuilder(
    column: $table.averageScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> attemptsRefs<T extends Object>(
    Expression<T> Function($$AttemptsTableAnnotationComposer a) f,
  ) {
    final $$AttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attempts,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.attempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> liveConversationsRefs<T extends Object>(
    Expression<T> Function($$LiveConversationsTableAnnotationComposer a) f,
  ) {
    final $$LiveConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.liveConversations,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LiveConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.liveConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$HandaDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool attemptsRefs,
            bool liveConversationsRefs,
          })
        > {
  $$SessionsTableTableManager(_$HandaDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> totalExercises = const Value.absent(),
                Value<int> completedExercises = const Value.absent(),
                Value<double?> averageScore = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                startedAt: startedAt,
                completedAt: completedAt,
                type: type,
                totalExercises: totalExercises,
                completedExercises: completedExercises,
                averageScore: averageScore,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required String type,
                Value<int> totalExercises = const Value.absent(),
                Value<int> completedExercises = const Value.absent(),
                Value<double?> averageScore = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                completedAt: completedAt,
                type: type,
                totalExercises: totalExercises,
                completedExercises: completedExercises,
                averageScore: averageScore,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SessionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            attemptsRefs = false,
            liveConversationsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attemptsRefs) db.attempts,
                if (liveConversationsRefs) db.liveConversations,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attemptsRefs)
                    await $_getPrefetchedData<Session, $SessionsTable, Attempt>(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._attemptsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).attemptsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.sessionId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (liveConversationsRefs)
                    await $_getPrefetchedData<
                      Session,
                      $SessionsTable,
                      LiveConversation
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._liveConversationsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).liveConversationsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.sessionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$HandaDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool attemptsRefs, bool liveConversationsRefs})
    >;
typedef $$AttemptsTableCreateCompanionBuilder =
    AttemptsCompanion Function({
      Value<int> id,
      required int sessionId,
      Value<int?> exerciseId,
      required String userResponse,
      required String expectedAnswer,
      required double scorePercentage,
      required String scoreLevel,
      Value<int?> responseTimeMs,
      Value<bool> isOffline,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });
typedef $$AttemptsTableUpdateCompanionBuilder =
    AttemptsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int?> exerciseId,
      Value<String> userResponse,
      Value<String> expectedAnswer,
      Value<double> scorePercentage,
      Value<String> scoreLevel,
      Value<int?> responseTimeMs,
      Value<bool> isOffline,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });

final class $$AttemptsTableReferences
    extends BaseReferences<_$HandaDatabase, $AttemptsTable, Attempt> {
  $$AttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$HandaDatabase db) => db.sessions
      .createAlias($_aliasNameGenerator(db.attempts.sessionId, db.sessions.id));

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$HandaDatabase db) =>
      db.exercises.createAlias(
        $_aliasNameGenerator(db.attempts.exerciseId, db.exercises.id),
      );

  $$ExercisesTableProcessedTableManager? get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id');
    if ($_column == null) return null;
    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttemptsTableFilterComposer
    extends Composer<_$HandaDatabase, $AttemptsTable> {
  $$AttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userResponse => $composableBuilder(
    column: $table.userResponse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedAnswer => $composableBuilder(
    column: $table.expectedAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scorePercentage => $composableBuilder(
    column: $table.scorePercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scoreLevel => $composableBuilder(
    column: $table.scoreLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOffline => $composableBuilder(
    column: $table.isOffline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptsTableOrderingComposer
    extends Composer<_$HandaDatabase, $AttemptsTable> {
  $$AttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userResponse => $composableBuilder(
    column: $table.userResponse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedAnswer => $composableBuilder(
    column: $table.expectedAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scorePercentage => $composableBuilder(
    column: $table.scorePercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scoreLevel => $composableBuilder(
    column: $table.scoreLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOffline => $composableBuilder(
    column: $table.isOffline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptsTableAnnotationComposer
    extends Composer<_$HandaDatabase, $AttemptsTable> {
  $$AttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userResponse => $composableBuilder(
    column: $table.userResponse,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectedAnswer => $composableBuilder(
    column: $table.expectedAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<double> get scorePercentage => $composableBuilder(
    column: $table.scorePercentage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scoreLevel => $composableBuilder(
    column: $table.scoreLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOffline =>
      $composableBuilder(column: $table.isOffline, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptsTableTableManager
    extends
        RootTableManager<
          _$HandaDatabase,
          $AttemptsTable,
          Attempt,
          $$AttemptsTableFilterComposer,
          $$AttemptsTableOrderingComposer,
          $$AttemptsTableAnnotationComposer,
          $$AttemptsTableCreateCompanionBuilder,
          $$AttemptsTableUpdateCompanionBuilder,
          (Attempt, $$AttemptsTableReferences),
          Attempt,
          PrefetchHooks Function({bool sessionId, bool exerciseId})
        > {
  $$AttemptsTableTableManager(_$HandaDatabase db, $AttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int?> exerciseId = const Value.absent(),
                Value<String> userResponse = const Value.absent(),
                Value<String> expectedAnswer = const Value.absent(),
                Value<double> scorePercentage = const Value.absent(),
                Value<String> scoreLevel = const Value.absent(),
                Value<int?> responseTimeMs = const Value.absent(),
                Value<bool> isOffline = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttemptsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                userResponse: userResponse,
                expectedAnswer: expectedAnswer,
                scorePercentage: scorePercentage,
                scoreLevel: scoreLevel,
                responseTimeMs: responseTimeMs,
                isOffline: isOffline,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                Value<int?> exerciseId = const Value.absent(),
                required String userResponse,
                required String expectedAnswer,
                required double scorePercentage,
                required String scoreLevel,
                Value<int?> responseTimeMs = const Value.absent(),
                Value<bool> isOffline = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttemptsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                userResponse: userResponse,
                expectedAnswer: expectedAnswer,
                scorePercentage: scorePercentage,
                scoreLevel: scoreLevel,
                responseTimeMs: responseTimeMs,
                isOffline: isOffline,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AttemptsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({sessionId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (sessionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$AttemptsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn:
                                $$AttemptsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (exerciseId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$AttemptsTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn:
                                $$AttemptsTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$HandaDatabase,
      $AttemptsTable,
      Attempt,
      $$AttemptsTableFilterComposer,
      $$AttemptsTableOrderingComposer,
      $$AttemptsTableAnnotationComposer,
      $$AttemptsTableCreateCompanionBuilder,
      $$AttemptsTableUpdateCompanionBuilder,
      (Attempt, $$AttemptsTableReferences),
      Attempt,
      PrefetchHooks Function({bool sessionId, bool exerciseId})
    >;
typedef $$LiveConversationsTableCreateCompanionBuilder =
    LiveConversationsCompanion Function({
      Value<int> id,
      required int sessionId,
      required String exerciseType,
      required int durationSeconds,
      required String userTranscript,
      required String aiFeedback,
      Value<double?> score,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });
typedef $$LiveConversationsTableUpdateCompanionBuilder =
    LiveConversationsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> exerciseType,
      Value<int> durationSeconds,
      Value<String> userTranscript,
      Value<String> aiFeedback,
      Value<double?> score,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });

final class $$LiveConversationsTableReferences
    extends
        BaseReferences<
          _$HandaDatabase,
          $LiveConversationsTable,
          LiveConversation
        > {
  $$LiveConversationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$HandaDatabase db) =>
      db.sessions.createAlias(
        $_aliasNameGenerator(db.liveConversations.sessionId, db.sessions.id),
      );

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LiveConversationsTableFilterComposer
    extends Composer<_$HandaDatabase, $LiveConversationsTable> {
  $$LiveConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userTranscript => $composableBuilder(
    column: $table.userTranscript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiFeedback => $composableBuilder(
    column: $table.aiFeedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LiveConversationsTableOrderingComposer
    extends Composer<_$HandaDatabase, $LiveConversationsTable> {
  $$LiveConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userTranscript => $composableBuilder(
    column: $table.userTranscript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiFeedback => $composableBuilder(
    column: $table.aiFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LiveConversationsTableAnnotationComposer
    extends Composer<_$HandaDatabase, $LiveConversationsTable> {
  $$LiveConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userTranscript => $composableBuilder(
    column: $table.userTranscript,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiFeedback => $composableBuilder(
    column: $table.aiFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LiveConversationsTableTableManager
    extends
        RootTableManager<
          _$HandaDatabase,
          $LiveConversationsTable,
          LiveConversation,
          $$LiveConversationsTableFilterComposer,
          $$LiveConversationsTableOrderingComposer,
          $$LiveConversationsTableAnnotationComposer,
          $$LiveConversationsTableCreateCompanionBuilder,
          $$LiveConversationsTableUpdateCompanionBuilder,
          (LiveConversation, $$LiveConversationsTableReferences),
          LiveConversation,
          PrefetchHooks Function({bool sessionId})
        > {
  $$LiveConversationsTableTableManager(
    _$HandaDatabase db,
    $LiveConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LiveConversationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$LiveConversationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$LiveConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> userTranscript = const Value.absent(),
                Value<String> aiFeedback = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LiveConversationsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseType: exerciseType,
                durationSeconds: durationSeconds,
                userTranscript: userTranscript,
                aiFeedback: aiFeedback,
                score: score,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String exerciseType,
                required int durationSeconds,
                required String userTranscript,
                required String aiFeedback,
                Value<double?> score = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LiveConversationsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseType: exerciseType,
                durationSeconds: durationSeconds,
                userTranscript: userTranscript,
                aiFeedback: aiFeedback,
                score: score,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$LiveConversationsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (sessionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$LiveConversationsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn:
                                $$LiveConversationsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LiveConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$HandaDatabase,
      $LiveConversationsTable,
      LiveConversation,
      $$LiveConversationsTableFilterComposer,
      $$LiveConversationsTableOrderingComposer,
      $$LiveConversationsTableAnnotationComposer,
      $$LiveConversationsTableCreateCompanionBuilder,
      $$LiveConversationsTableUpdateCompanionBuilder,
      (LiveConversation, $$LiveConversationsTableReferences),
      LiveConversation,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$HandaDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$HandaDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$HandaDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$HandaDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$HandaDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$HandaDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$HandaDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$HandaDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$SyncLogTableCreateCompanionBuilder =
    SyncLogCompanion Function({
      Value<int> id,
      required String entityType,
      required int recordId,
      required String action,
      Value<DateTime> syncedAt,
      Value<String> status,
    });
typedef $$SyncLogTableUpdateCompanionBuilder =
    SyncLogCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<int> recordId,
      Value<String> action,
      Value<DateTime> syncedAt,
      Value<String> status,
    });

class $$SyncLogTableFilterComposer
    extends Composer<_$HandaDatabase, $SyncLogTable> {
  $$SyncLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncLogTableOrderingComposer
    extends Composer<_$HandaDatabase, $SyncLogTable> {
  $$SyncLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLogTableAnnotationComposer
    extends Composer<_$HandaDatabase, $SyncLogTable> {
  $$SyncLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncLogTableTableManager
    extends
        RootTableManager<
          _$HandaDatabase,
          $SyncLogTable,
          SyncLogData,
          $$SyncLogTableFilterComposer,
          $$SyncLogTableOrderingComposer,
          $$SyncLogTableAnnotationComposer,
          $$SyncLogTableCreateCompanionBuilder,
          $$SyncLogTableUpdateCompanionBuilder,
          (
            SyncLogData,
            BaseReferences<_$HandaDatabase, $SyncLogTable, SyncLogData>,
          ),
          SyncLogData,
          PrefetchHooks Function()
        > {
  $$SyncLogTableTableManager(_$HandaDatabase db, $SyncLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SyncLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SyncLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SyncLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> recordId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => SyncLogCompanion(
                id: id,
                entityType: entityType,
                recordId: recordId,
                action: action,
                syncedAt: syncedAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required int recordId,
                required String action,
                Value<DateTime> syncedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => SyncLogCompanion.insert(
                id: id,
                entityType: entityType,
                recordId: recordId,
                action: action,
                syncedAt: syncedAt,
                status: status,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLogTableProcessedTableManager =
    ProcessedTableManager<
      _$HandaDatabase,
      $SyncLogTable,
      SyncLogData,
      $$SyncLogTableFilterComposer,
      $$SyncLogTableOrderingComposer,
      $$SyncLogTableAnnotationComposer,
      $$SyncLogTableCreateCompanionBuilder,
      $$SyncLogTableUpdateCompanionBuilder,
      (
        SyncLogData,
        BaseReferences<_$HandaDatabase, $SyncLogTable, SyncLogData>,
      ),
      SyncLogData,
      PrefetchHooks Function()
    >;

class $HandaDatabaseManager {
  final _$HandaDatabase _db;
  $HandaDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$AttemptsTableTableManager get attempts =>
      $$AttemptsTableTableManager(_db, _db.attempts);
  $$LiveConversationsTableTableManager get liveConversations =>
      $$LiveConversationsTableTableManager(_db, _db.liveConversations);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SyncLogTableTableManager get syncLog =>
      $$SyncLogTableTableManager(_db, _db.syncLog);
}
