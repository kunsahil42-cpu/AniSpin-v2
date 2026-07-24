// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadingProgressCollection on Isar {
  IsarCollection<ReadingProgress> get readingProgress => this.collection();
}

const ReadingProgressSchema = CollectionSchema(
  name: r'ReadingProgress',
  id: -2251063111460261641,
  properties: {
    r'aniListId': PropertySchema(
      id: 0,
      name: r'aniListId',
      type: IsarType.long,
    ),
    r'author': PropertySchema(
      id: 1,
      name: r'author',
      type: IsarType.string,
    ),
    r'bannerImage': PropertySchema(
      id: 2,
      name: r'bannerImage',
      type: IsarType.string,
    ),
    r'completedChapters': PropertySchema(
      id: 3,
      name: r'completedChapters',
      type: IsarType.longList,
    ),
    r'coverImage': PropertySchema(
      id: 4,
      name: r'coverImage',
      type: IsarType.string,
    ),
    r'dateFinished': PropertySchema(
      id: 5,
      name: r'dateFinished',
      type: IsarType.dateTime,
    ),
    r'dateStarted': PropertySchema(
      id: 6,
      name: r'dateStarted',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 7,
      name: r'description',
      type: IsarType.string,
    ),
    r'englishTitle': PropertySchema(
      id: 8,
      name: r'englishTitle',
      type: IsarType.string,
    ),
    r'genres': PropertySchema(
      id: 9,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'lastReadAt': PropertySchema(
      id: 10,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'lastReadChapter': PropertySchema(
      id: 11,
      name: r'lastReadChapter',
      type: IsarType.long,
    ),
    r'lastReadPage': PropertySchema(
      id: 12,
      name: r'lastReadPage',
      type: IsarType.long,
    ),
    r'lastReadVolume': PropertySchema(
      id: 13,
      name: r'lastReadVolume',
      type: IsarType.long,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 14,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'malId': PropertySchema(
      id: 15,
      name: r'malId',
      type: IsarType.long,
    ),
    r'mangaDexId': PropertySchema(
      id: 16,
      name: r'mangaDexId',
      type: IsarType.string,
    ),
    r'mangaId': PropertySchema(
      id: 17,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 18,
      name: r'notes',
      type: IsarType.string,
    ),
    r'readingPercentage': PropertySchema(
      id: 19,
      name: r'readingPercentage',
      type: IsarType.double,
    ),
    r'rereadCount': PropertySchema(
      id: 20,
      name: r'rereadCount',
      type: IsarType.long,
    ),
    r'romajiTitle': PropertySchema(
      id: 21,
      name: r'romajiTitle',
      type: IsarType.string,
    ),
    r'score': PropertySchema(
      id: 22,
      name: r'score',
      type: IsarType.long,
    ),
    r'sourceName': PropertySchema(
      id: 23,
      name: r'sourceName',
      type: IsarType.string,
    ),
    r'sourceType': PropertySchema(
      id: 24,
      name: r'sourceType',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 25,
      name: r'status',
      type: IsarType.string,
    ),
    r'totalChapters': PropertySchema(
      id: 26,
      name: r'totalChapters',
      type: IsarType.long,
    ),
    r'totalVolumes': PropertySchema(
      id: 27,
      name: r'totalVolumes',
      type: IsarType.long,
    )
  },
  estimateSize: _readingProgressEstimateSize,
  serialize: _readingProgressSerialize,
  deserialize: _readingProgressDeserialize,
  deserializeProp: _readingProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'mangaId': IndexSchema(
      id: 7466570075891278896,
      name: r'mangaId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mangaId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _readingProgressGetId,
  getLinks: _readingProgressGetLinks,
  attach: _readingProgressAttach,
  version: '3.1.0+1',
);

int _readingProgressEstimateSize(
  ReadingProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.author;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bannerImage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.completedChapters.length * 8;
  bytesCount += 3 + object.coverImage.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.englishTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.genres.length * 3;
  {
    for (var i = 0; i < object.genres.length; i++) {
      final value = object.genres[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.mangaDexId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.romajiTitle.length * 3;
  {
    final value = object.sourceName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _readingProgressSerialize(
  ReadingProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.aniListId);
  writer.writeString(offsets[1], object.author);
  writer.writeString(offsets[2], object.bannerImage);
  writer.writeLongList(offsets[3], object.completedChapters);
  writer.writeString(offsets[4], object.coverImage);
  writer.writeDateTime(offsets[5], object.dateFinished);
  writer.writeDateTime(offsets[6], object.dateStarted);
  writer.writeString(offsets[7], object.description);
  writer.writeString(offsets[8], object.englishTitle);
  writer.writeStringList(offsets[9], object.genres);
  writer.writeDateTime(offsets[10], object.lastReadAt);
  writer.writeLong(offsets[11], object.lastReadChapter);
  writer.writeLong(offsets[12], object.lastReadPage);
  writer.writeLong(offsets[13], object.lastReadVolume);
  writer.writeDateTime(offsets[14], object.lastSyncedAt);
  writer.writeLong(offsets[15], object.malId);
  writer.writeString(offsets[16], object.mangaDexId);
  writer.writeLong(offsets[17], object.mangaId);
  writer.writeString(offsets[18], object.notes);
  writer.writeDouble(offsets[19], object.readingPercentage);
  writer.writeLong(offsets[20], object.rereadCount);
  writer.writeString(offsets[21], object.romajiTitle);
  writer.writeLong(offsets[22], object.score);
  writer.writeString(offsets[23], object.sourceName);
  writer.writeString(offsets[24], object.sourceType);
  writer.writeString(offsets[25], object.status);
  writer.writeLong(offsets[26], object.totalChapters);
  writer.writeLong(offsets[27], object.totalVolumes);
}

ReadingProgress _readingProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingProgress();
  object.aniListId = reader.readLongOrNull(offsets[0]);
  object.author = reader.readStringOrNull(offsets[1]);
  object.bannerImage = reader.readStringOrNull(offsets[2]);
  object.completedChapters = reader.readLongList(offsets[3]) ?? [];
  object.coverImage = reader.readString(offsets[4]);
  object.dateFinished = reader.readDateTimeOrNull(offsets[5]);
  object.dateStarted = reader.readDateTimeOrNull(offsets[6]);
  object.description = reader.readStringOrNull(offsets[7]);
  object.englishTitle = reader.readStringOrNull(offsets[8]);
  object.genres = reader.readStringList(offsets[9]) ?? [];
  object.id = id;
  object.lastReadAt = reader.readDateTime(offsets[10]);
  object.lastReadChapter = reader.readLong(offsets[11]);
  object.lastReadPage = reader.readLong(offsets[12]);
  object.lastReadVolume = reader.readLong(offsets[13]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[14]);
  object.malId = reader.readLongOrNull(offsets[15]);
  object.mangaDexId = reader.readStringOrNull(offsets[16]);
  object.mangaId = reader.readLong(offsets[17]);
  object.notes = reader.readStringOrNull(offsets[18]);
  object.readingPercentage = reader.readDouble(offsets[19]);
  object.rereadCount = reader.readLong(offsets[20]);
  object.romajiTitle = reader.readString(offsets[21]);
  object.score = reader.readLongOrNull(offsets[22]);
  object.sourceName = reader.readStringOrNull(offsets[23]);
  object.sourceType = reader.readStringOrNull(offsets[24]);
  object.status = reader.readStringOrNull(offsets[25]);
  object.totalChapters = reader.readLongOrNull(offsets[26]);
  object.totalVolumes = reader.readLongOrNull(offsets[27]);
  return object;
}

P _readingProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? []) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringList(offset) ?? []) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readDouble(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readLongOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readLongOrNull(offset)) as P;
    case 27:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _readingProgressGetId(ReadingProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readingProgressGetLinks(ReadingProgress object) {
  return [];
}

void _readingProgressAttach(
    IsarCollection<dynamic> col, Id id, ReadingProgress object) {
  object.id = id;
}

extension ReadingProgressByIndex on IsarCollection<ReadingProgress> {
  Future<ReadingProgress?> getByMangaId(int mangaId) {
    return getByIndex(r'mangaId', [mangaId]);
  }

  ReadingProgress? getByMangaIdSync(int mangaId) {
    return getByIndexSync(r'mangaId', [mangaId]);
  }

  Future<bool> deleteByMangaId(int mangaId) {
    return deleteByIndex(r'mangaId', [mangaId]);
  }

  bool deleteByMangaIdSync(int mangaId) {
    return deleteByIndexSync(r'mangaId', [mangaId]);
  }

  Future<List<ReadingProgress?>> getAllByMangaId(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'mangaId', values);
  }

  List<ReadingProgress?> getAllByMangaIdSync(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'mangaId', values);
  }

  Future<int> deleteAllByMangaId(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'mangaId', values);
  }

  int deleteAllByMangaIdSync(List<int> mangaIdValues) {
    final values = mangaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'mangaId', values);
  }

  Future<Id> putByMangaId(ReadingProgress object) {
    return putByIndex(r'mangaId', object);
  }

  Id putByMangaIdSync(ReadingProgress object, {bool saveLinks = true}) {
    return putByIndexSync(r'mangaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMangaId(List<ReadingProgress> objects) {
    return putAllByIndex(r'mangaId', objects);
  }

  List<Id> putAllByMangaIdSync(List<ReadingProgress> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'mangaId', objects, saveLinks: saveLinks);
  }
}

extension ReadingProgressQueryWhereSort
    on QueryBuilder<ReadingProgress, ReadingProgress, QWhere> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhere> anyMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mangaId'),
      );
    });
  }
}

extension ReadingProgressQueryWhere
    on QueryBuilder<ReadingProgress, ReadingProgress, QWhereClause> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdEqualTo(int mangaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mangaId',
        value: [mangaId],
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdNotEqualTo(int mangaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [mangaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mangaId',
              lower: [],
              upper: [mangaId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdGreaterThan(
    int mangaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mangaId',
        lower: [mangaId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdLessThan(
    int mangaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mangaId',
        lower: [],
        upper: [mangaId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterWhereClause>
      mangaIdBetween(
    int lowerMangaId,
    int upperMangaId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mangaId',
        lower: [lowerMangaId],
        includeLower: includeLower,
        upper: [upperMangaId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingProgressQueryFilter
    on QueryBuilder<ReadingProgress, ReadingProgress, QFilterCondition> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      aniListIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'aniListId',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      aniListIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'aniListId',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      aniListIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aniListId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      aniListIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aniListId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      aniListIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aniListId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      aniListIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aniListId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'author',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      authorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'author',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bannerImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bannerImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      bannerImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedChapters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      completedChaptersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedChapters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coverImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      coverImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateFinishedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateFinished',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateFinishedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateFinished',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateFinishedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFinished',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateFinishedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateFinished',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateFinishedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateFinished',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateFinishedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateFinished',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateStartedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateStarted',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateStartedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateStarted',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateStartedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateStarted',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateStartedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateStarted',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateStartedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateStarted',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      dateStartedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateStarted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'englishTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'englishTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      englishTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'genres',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genres',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      genresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadChapter',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadChapterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadChapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadVolumeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadVolume',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadVolumeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadVolume',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadVolumeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadVolume',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastReadVolumeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      malIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'malId',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      malIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'malId',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      malIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'malId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      malIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'malId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      malIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'malId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      malIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'malId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaDexId',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaDexId',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaDexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mangaDexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mangaDexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mangaDexId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mangaDexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mangaDexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mangaDexId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mangaDexId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaDexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaDexIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mangaDexId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      mangaIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mangaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readingPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readingPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readingPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      readingPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readingPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      rereadCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rereadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      rereadCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rereadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      rereadCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rereadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      rereadCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rereadCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'romajiTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'romajiTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      romajiTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      scoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'score',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      scoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'score',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      scoreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      scoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      scoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      scoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceName',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceName',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceName',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceName',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceType',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceType',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceType',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      sourceTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceType',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalChapters',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalChapters',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalChaptersBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalChapters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalVolumesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalVolumes',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalVolumesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalVolumes',
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalVolumesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalVolumes',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalVolumesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalVolumes',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalVolumesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalVolumes',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition>
      totalVolumesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalVolumes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingProgressQueryObject
    on QueryBuilder<ReadingProgress, ReadingProgress, QFilterCondition> {}

extension ReadingProgressQueryLinks
    on QueryBuilder<ReadingProgress, ReadingProgress, QFilterCondition> {}

extension ReadingProgressQuerySortBy
    on QueryBuilder<ReadingProgress, ReadingProgress, QSortBy> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByAniListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniListId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByAniListIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniListId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByDateFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByDateFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByDateStartedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadVolume', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastReadVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadVolume', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByMalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByMangaDexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaDexId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByMangaDexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaDexId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByReadingPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByReadingPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByRereadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rereadCount', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByRereadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rereadCount', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByTotalChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByTotalChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByTotalVolumes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumes', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      sortByTotalVolumesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumes', Sort.desc);
    });
  }
}

extension ReadingProgressQuerySortThenBy
    on QueryBuilder<ReadingProgress, ReadingProgress, QSortThenBy> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByAniListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniListId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByAniListIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniListId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'author', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByDateFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByDateFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByDateStartedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadChapter', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadVolume', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastReadVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadVolume', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByMalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByMangaDexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaDexId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByMangaDexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaDexId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByReadingPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByReadingPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingPercentage', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByRereadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rereadCount', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByRereadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rereadCount', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByTotalChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByTotalChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapters', Sort.desc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByTotalVolumes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumes', Sort.asc);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy>
      thenByTotalVolumesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalVolumes', Sort.desc);
    });
  }
}

extension ReadingProgressQueryWhereDistinct
    on QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> {
  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByAniListId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aniListId');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> distinctByAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'author', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByBannerImage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bannerImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByCompletedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedChapters');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByCoverImage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByDateFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFinished');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateStarted');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByEnglishTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'englishTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadAt');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastReadChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadChapter');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadPage');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastReadVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadVolume');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> distinctByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'malId');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByMangaDexId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaDexId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByReadingPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingPercentage');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByRereadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rereadCount');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByRomajiTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'romajiTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctBySourceName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctBySourceType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByTotalChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChapters');
    });
  }

  QueryBuilder<ReadingProgress, ReadingProgress, QDistinct>
      distinctByTotalVolumes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalVolumes');
    });
  }
}

extension ReadingProgressQueryProperty
    on QueryBuilder<ReadingProgress, ReadingProgress, QQueryProperty> {
  QueryBuilder<ReadingProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingProgress, int?, QQueryOperations> aniListIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aniListId');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations> authorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'author');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      bannerImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bannerImage');
    });
  }

  QueryBuilder<ReadingProgress, List<int>, QQueryOperations>
      completedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedChapters');
    });
  }

  QueryBuilder<ReadingProgress, String, QQueryOperations> coverImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverImage');
    });
  }

  QueryBuilder<ReadingProgress, DateTime?, QQueryOperations>
      dateFinishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFinished');
    });
  }

  QueryBuilder<ReadingProgress, DateTime?, QQueryOperations>
      dateStartedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateStarted');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      englishTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'englishTitle');
    });
  }

  QueryBuilder<ReadingProgress, List<String>, QQueryOperations>
      genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<ReadingProgress, DateTime, QQueryOperations>
      lastReadAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadAt');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations>
      lastReadChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadChapter');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations> lastReadPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadPage');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations>
      lastReadVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadVolume');
    });
  }

  QueryBuilder<ReadingProgress, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<ReadingProgress, int?, QQueryOperations> malIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'malId');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      mangaDexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaDexId');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<ReadingProgress, double, QQueryOperations>
      readingPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingPercentage');
    });
  }

  QueryBuilder<ReadingProgress, int, QQueryOperations> rereadCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rereadCount');
    });
  }

  QueryBuilder<ReadingProgress, String, QQueryOperations>
      romajiTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'romajiTitle');
    });
  }

  QueryBuilder<ReadingProgress, int?, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      sourceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceName');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations>
      sourceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceType');
    });
  }

  QueryBuilder<ReadingProgress, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<ReadingProgress, int?, QQueryOperations>
      totalChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChapters');
    });
  }

  QueryBuilder<ReadingProgress, int?, QQueryOperations> totalVolumesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalVolumes');
    });
  }
}
