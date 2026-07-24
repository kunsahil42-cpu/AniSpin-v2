// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWatchProgressCollection on Isar {
  IsarCollection<WatchProgress> get watchProgress => this.collection();
}

const WatchProgressSchema = CollectionSchema(
  name: r'WatchProgress',
  id: -7341403213961839091,
  properties: {
    r'animeId': PropertySchema(
      id: 0,
      name: r'animeId',
      type: IsarType.long,
    ),
    r'bannerImage': PropertySchema(
      id: 1,
      name: r'bannerImage',
      type: IsarType.string,
    ),
    r'completedEpisodes': PropertySchema(
      id: 2,
      name: r'completedEpisodes',
      type: IsarType.longList,
    ),
    r'coverImage': PropertySchema(
      id: 3,
      name: r'coverImage',
      type: IsarType.string,
    ),
    r'dateFinished': PropertySchema(
      id: 4,
      name: r'dateFinished',
      type: IsarType.dateTime,
    ),
    r'dateStarted': PropertySchema(
      id: 5,
      name: r'dateStarted',
      type: IsarType.dateTime,
    ),
    r'englishTitle': PropertySchema(
      id: 6,
      name: r'englishTitle',
      type: IsarType.string,
    ),
    r'genres': PropertySchema(
      id: 7,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'lastWatchedAt': PropertySchema(
      id: 8,
      name: r'lastWatchedAt',
      type: IsarType.dateTime,
    ),
    r'lastWatchedAudio': PropertySchema(
      id: 9,
      name: r'lastWatchedAudio',
      type: IsarType.string,
    ),
    r'lastWatchedDuration': PropertySchema(
      id: 10,
      name: r'lastWatchedDuration',
      type: IsarType.long,
    ),
    r'lastWatchedEpisode': PropertySchema(
      id: 11,
      name: r'lastWatchedEpisode',
      type: IsarType.long,
    ),
    r'lastWatchedPosition': PropertySchema(
      id: 12,
      name: r'lastWatchedPosition',
      type: IsarType.long,
    ),
    r'lastWatchedSource': PropertySchema(
      id: 13,
      name: r'lastWatchedSource',
      type: IsarType.string,
    ),
    r'malId': PropertySchema(
      id: 14,
      name: r'malId',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 15,
      name: r'notes',
      type: IsarType.string,
    ),
    r'rewatchCount': PropertySchema(
      id: 16,
      name: r'rewatchCount',
      type: IsarType.long,
    ),
    r'romajiTitle': PropertySchema(
      id: 17,
      name: r'romajiTitle',
      type: IsarType.string,
    ),
    r'score': PropertySchema(
      id: 18,
      name: r'score',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 19,
      name: r'status',
      type: IsarType.string,
    ),
    r'studio': PropertySchema(
      id: 20,
      name: r'studio',
      type: IsarType.string,
    ),
    r'totalEpisodes': PropertySchema(
      id: 21,
      name: r'totalEpisodes',
      type: IsarType.long,
    ),
    r'watchPercentage': PropertySchema(
      id: 22,
      name: r'watchPercentage',
      type: IsarType.double,
    )
  },
  estimateSize: _watchProgressEstimateSize,
  serialize: _watchProgressSerialize,
  deserialize: _watchProgressDeserialize,
  deserializeProp: _watchProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'animeId': IndexSchema(
      id: 4402861282981058668,
      name: r'animeId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'animeId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _watchProgressGetId,
  getLinks: _watchProgressGetLinks,
  attach: _watchProgressAttach,
  version: '3.1.0+1',
);

int _watchProgressEstimateSize(
  WatchProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bannerImage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.completedEpisodes.length * 8;
  bytesCount += 3 + object.coverImage.length * 3;
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
  bytesCount += 3 + object.lastWatchedAudio.length * 3;
  bytesCount += 3 + object.lastWatchedSource.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.romajiTitle.length * 3;
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.studio;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _watchProgressSerialize(
  WatchProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.animeId);
  writer.writeString(offsets[1], object.bannerImage);
  writer.writeLongList(offsets[2], object.completedEpisodes);
  writer.writeString(offsets[3], object.coverImage);
  writer.writeDateTime(offsets[4], object.dateFinished);
  writer.writeDateTime(offsets[5], object.dateStarted);
  writer.writeString(offsets[6], object.englishTitle);
  writer.writeStringList(offsets[7], object.genres);
  writer.writeDateTime(offsets[8], object.lastWatchedAt);
  writer.writeString(offsets[9], object.lastWatchedAudio);
  writer.writeLong(offsets[10], object.lastWatchedDuration);
  writer.writeLong(offsets[11], object.lastWatchedEpisode);
  writer.writeLong(offsets[12], object.lastWatchedPosition);
  writer.writeString(offsets[13], object.lastWatchedSource);
  writer.writeLong(offsets[14], object.malId);
  writer.writeString(offsets[15], object.notes);
  writer.writeLong(offsets[16], object.rewatchCount);
  writer.writeString(offsets[17], object.romajiTitle);
  writer.writeLong(offsets[18], object.score);
  writer.writeString(offsets[19], object.status);
  writer.writeString(offsets[20], object.studio);
  writer.writeLong(offsets[21], object.totalEpisodes);
  writer.writeDouble(offsets[22], object.watchPercentage);
}

WatchProgress _watchProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WatchProgress();
  object.animeId = reader.readLong(offsets[0]);
  object.bannerImage = reader.readStringOrNull(offsets[1]);
  object.completedEpisodes = reader.readLongList(offsets[2]) ?? [];
  object.coverImage = reader.readString(offsets[3]);
  object.dateFinished = reader.readDateTimeOrNull(offsets[4]);
  object.dateStarted = reader.readDateTimeOrNull(offsets[5]);
  object.englishTitle = reader.readStringOrNull(offsets[6]);
  object.genres = reader.readStringList(offsets[7]) ?? [];
  object.id = id;
  object.lastWatchedAt = reader.readDateTime(offsets[8]);
  object.lastWatchedAudio = reader.readString(offsets[9]);
  object.lastWatchedDuration = reader.readLong(offsets[10]);
  object.lastWatchedEpisode = reader.readLong(offsets[11]);
  object.lastWatchedPosition = reader.readLong(offsets[12]);
  object.lastWatchedSource = reader.readString(offsets[13]);
  object.malId = reader.readLongOrNull(offsets[14]);
  object.notes = reader.readStringOrNull(offsets[15]);
  object.rewatchCount = reader.readLong(offsets[16]);
  object.romajiTitle = reader.readString(offsets[17]);
  object.score = reader.readLongOrNull(offsets[18]);
  object.status = reader.readStringOrNull(offsets[19]);
  object.studio = reader.readStringOrNull(offsets[20]);
  object.totalEpisodes = reader.readLongOrNull(offsets[21]);
  object.watchPercentage = reader.readDouble(offsets[22]);
  return object;
}

P _watchProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readLongOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset)) as P;
    case 22:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _watchProgressGetId(WatchProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _watchProgressGetLinks(WatchProgress object) {
  return [];
}

void _watchProgressAttach(
    IsarCollection<dynamic> col, Id id, WatchProgress object) {
  object.id = id;
}

extension WatchProgressByIndex on IsarCollection<WatchProgress> {
  Future<WatchProgress?> getByAnimeId(int animeId) {
    return getByIndex(r'animeId', [animeId]);
  }

  WatchProgress? getByAnimeIdSync(int animeId) {
    return getByIndexSync(r'animeId', [animeId]);
  }

  Future<bool> deleteByAnimeId(int animeId) {
    return deleteByIndex(r'animeId', [animeId]);
  }

  bool deleteByAnimeIdSync(int animeId) {
    return deleteByIndexSync(r'animeId', [animeId]);
  }

  Future<List<WatchProgress?>> getAllByAnimeId(List<int> animeIdValues) {
    final values = animeIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'animeId', values);
  }

  List<WatchProgress?> getAllByAnimeIdSync(List<int> animeIdValues) {
    final values = animeIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'animeId', values);
  }

  Future<int> deleteAllByAnimeId(List<int> animeIdValues) {
    final values = animeIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'animeId', values);
  }

  int deleteAllByAnimeIdSync(List<int> animeIdValues) {
    final values = animeIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'animeId', values);
  }

  Future<Id> putByAnimeId(WatchProgress object) {
    return putByIndex(r'animeId', object);
  }

  Id putByAnimeIdSync(WatchProgress object, {bool saveLinks = true}) {
    return putByIndexSync(r'animeId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAnimeId(List<WatchProgress> objects) {
    return putAllByIndex(r'animeId', objects);
  }

  List<Id> putAllByAnimeIdSync(List<WatchProgress> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'animeId', objects, saveLinks: saveLinks);
  }
}

extension WatchProgressQueryWhereSort
    on QueryBuilder<WatchProgress, WatchProgress, QWhere> {
  QueryBuilder<WatchProgress, WatchProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhere> anyAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'animeId'),
      );
    });
  }
}

extension WatchProgressQueryWhere
    on QueryBuilder<WatchProgress, WatchProgress, QWhereClause> {
  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> idBetween(
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> animeIdEqualTo(
      int animeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'animeId',
        value: [animeId],
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause>
      animeIdNotEqualTo(int animeId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animeId',
              lower: [],
              upper: [animeId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animeId',
              lower: [animeId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animeId',
              lower: [animeId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'animeId',
              lower: [],
              upper: [animeId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause>
      animeIdGreaterThan(
    int animeId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'animeId',
        lower: [animeId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> animeIdLessThan(
    int animeId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'animeId',
        lower: [],
        upper: [animeId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterWhereClause> animeIdBetween(
    int lowerAnimeId,
    int upperAnimeId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'animeId',
        lower: [lowerAnimeId],
        includeLower: includeLower,
        upper: [upperAnimeId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WatchProgressQueryFilter
    on QueryBuilder<WatchProgress, WatchProgress, QFilterCondition> {
  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      animeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeId',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      animeIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'animeId',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      animeIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'animeId',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      animeIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'animeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      bannerImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      bannerImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      bannerImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      bannerImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bannerImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      bannerImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      bannerImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedEpisodes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedEpisodes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedEpisodes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedEpisodes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedEpisodes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedEpisodes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      completedEpisodesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedEpisodes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      coverImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      coverImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      coverImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      coverImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      dateFinishedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateFinished',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      dateFinishedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateFinished',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      dateFinishedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFinished',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      dateStartedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateStarted',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      dateStartedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateStarted',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      dateStartedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateStarted',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      englishTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      englishTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      englishTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      englishTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'englishTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      englishTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      englishTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      genresElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'genres',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      genresElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'genres',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'genres',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWatchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWatchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWatchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedAudio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWatchedAudio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWatchedAudio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWatchedAudio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastWatchedAudio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastWatchedAudio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastWatchedAudio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastWatchedAudio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedAudio',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedAudioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastWatchedAudio',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWatchedDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWatchedDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWatchedDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedEpisodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedEpisode',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedEpisodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWatchedEpisode',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedEpisodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWatchedEpisode',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedEpisodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWatchedEpisode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedPositionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedPositionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWatchedPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedPositionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWatchedPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedPositionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWatchedPosition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastWatchedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastWatchedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastWatchedSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastWatchedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastWatchedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastWatchedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastWatchedSource',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastWatchedSource',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      lastWatchedSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastWatchedSource',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      malIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'malId',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      malIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'malId',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      malIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'malId',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      rewatchCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewatchCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      rewatchCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rewatchCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      rewatchCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rewatchCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      rewatchCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rewatchCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      romajiTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      romajiTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'romajiTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      romajiTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      romajiTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      scoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'score',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      scoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'score',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      scoreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'score',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
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

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'studio',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'studio',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'studio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'studio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'studio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'studio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'studio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'studio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'studio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'studio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'studio',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      studioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'studio',
        value: '',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      totalEpisodesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalEpisodes',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      totalEpisodesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalEpisodes',
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      totalEpisodesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      totalEpisodesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      totalEpisodesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalEpisodes',
        value: value,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      totalEpisodesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalEpisodes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      watchPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'watchPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      watchPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'watchPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      watchPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'watchPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition>
      watchPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'watchPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension WatchProgressQueryObject
    on QueryBuilder<WatchProgress, WatchProgress, QFilterCondition> {}

extension WatchProgressQueryLinks
    on QueryBuilder<WatchProgress, WatchProgress, QFilterCondition> {}

extension WatchProgressQuerySortBy
    on QueryBuilder<WatchProgress, WatchProgress, QSortBy> {
  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByAnimeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByDateFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByDateFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByDateStartedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAt', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAt', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedAudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAudio', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedAudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAudio', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedDuration', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedDuration', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedEpisode', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedEpisode', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedPosition', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedPosition', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedSource', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByLastWatchedSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedSource', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByMalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByRewatchCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewatchCount', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByRewatchCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewatchCount', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByStudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByStudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByTotalEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByTotalEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByWatchPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchPercentage', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      sortByWatchPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchPercentage', Sort.desc);
    });
  }
}

extension WatchProgressQuerySortThenBy
    on QueryBuilder<WatchProgress, WatchProgress, QSortThenBy> {
  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByAnimeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByDateFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByDateFinishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFinished', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByDateStartedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateStarted', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAt', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAt', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedAudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAudio', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedAudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAudio', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedDuration', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedDuration', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedEpisode', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedEpisode', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedPosition', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedPosition', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedSource', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByLastWatchedSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedSource', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByMalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'malId', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByRewatchCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewatchCount', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByRewatchCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewatchCount', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByStudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> thenByStudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByTotalEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByTotalEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalEpisodes', Sort.desc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByWatchPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchPercentage', Sort.asc);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy>
      thenByWatchPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'watchPercentage', Sort.desc);
    });
  }
}

extension WatchProgressQueryWhereDistinct
    on QueryBuilder<WatchProgress, WatchProgress, QDistinct> {
  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeId');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByBannerImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bannerImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByCompletedEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedEpisodes');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByCoverImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByDateFinished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFinished');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByDateStarted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateStarted');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByEnglishTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'englishTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByLastWatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWatchedAt');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByLastWatchedAudio({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWatchedAudio',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByLastWatchedDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWatchedDuration');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByLastWatchedEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWatchedEpisode');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByLastWatchedPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWatchedPosition');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByLastWatchedSource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWatchedSource',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByMalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'malId');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByRewatchCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewatchCount');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByRomajiTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'romajiTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct> distinctByStudio(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'studio', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByTotalEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalEpisodes');
    });
  }

  QueryBuilder<WatchProgress, WatchProgress, QDistinct>
      distinctByWatchPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'watchPercentage');
    });
  }
}

extension WatchProgressQueryProperty
    on QueryBuilder<WatchProgress, WatchProgress, QQueryProperty> {
  QueryBuilder<WatchProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WatchProgress, int, QQueryOperations> animeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeId');
    });
  }

  QueryBuilder<WatchProgress, String?, QQueryOperations> bannerImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bannerImage');
    });
  }

  QueryBuilder<WatchProgress, List<int>, QQueryOperations>
      completedEpisodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedEpisodes');
    });
  }

  QueryBuilder<WatchProgress, String, QQueryOperations> coverImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverImage');
    });
  }

  QueryBuilder<WatchProgress, DateTime?, QQueryOperations>
      dateFinishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFinished');
    });
  }

  QueryBuilder<WatchProgress, DateTime?, QQueryOperations>
      dateStartedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateStarted');
    });
  }

  QueryBuilder<WatchProgress, String?, QQueryOperations>
      englishTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'englishTitle');
    });
  }

  QueryBuilder<WatchProgress, List<String>, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<WatchProgress, DateTime, QQueryOperations>
      lastWatchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWatchedAt');
    });
  }

  QueryBuilder<WatchProgress, String, QQueryOperations>
      lastWatchedAudioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWatchedAudio');
    });
  }

  QueryBuilder<WatchProgress, int, QQueryOperations>
      lastWatchedDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWatchedDuration');
    });
  }

  QueryBuilder<WatchProgress, int, QQueryOperations>
      lastWatchedEpisodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWatchedEpisode');
    });
  }

  QueryBuilder<WatchProgress, int, QQueryOperations>
      lastWatchedPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWatchedPosition');
    });
  }

  QueryBuilder<WatchProgress, String, QQueryOperations>
      lastWatchedSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWatchedSource');
    });
  }

  QueryBuilder<WatchProgress, int?, QQueryOperations> malIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'malId');
    });
  }

  QueryBuilder<WatchProgress, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<WatchProgress, int, QQueryOperations> rewatchCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewatchCount');
    });
  }

  QueryBuilder<WatchProgress, String, QQueryOperations> romajiTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'romajiTitle');
    });
  }

  QueryBuilder<WatchProgress, int?, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<WatchProgress, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<WatchProgress, String?, QQueryOperations> studioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'studio');
    });
  }

  QueryBuilder<WatchProgress, int?, QQueryOperations> totalEpisodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalEpisodes');
    });
  }

  QueryBuilder<WatchProgress, double, QQueryOperations>
      watchPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'watchPercentage');
    });
  }
}
