// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_anime.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteAnimeCollection on Isar {
  IsarCollection<FavoriteAnime> get favoriteAnimes => this.collection();
}

const FavoriteAnimeSchema = CollectionSchema(
  name: r'FavoriteAnime',
  id: 1117026846889546848,
  properties: {
    r'addedAt': PropertySchema(
      id: 0,
      name: r'addedAt',
      type: IsarType.dateTime,
    ),
    r'animeId': PropertySchema(
      id: 1,
      name: r'animeId',
      type: IsarType.long,
    ),
    r'averageScore': PropertySchema(
      id: 2,
      name: r'averageScore',
      type: IsarType.long,
    ),
    r'bannerImage': PropertySchema(
      id: 3,
      name: r'bannerImage',
      type: IsarType.string,
    ),
    r'coverImage': PropertySchema(
      id: 4,
      name: r'coverImage',
      type: IsarType.string,
    ),
    r'englishTitle': PropertySchema(
      id: 5,
      name: r'englishTitle',
      type: IsarType.string,
    ),
    r'episodes': PropertySchema(
      id: 6,
      name: r'episodes',
      type: IsarType.long,
    ),
    r'romajiTitle': PropertySchema(
      id: 7,
      name: r'romajiTitle',
      type: IsarType.string,
    ),
    r'season': PropertySchema(
      id: 8,
      name: r'season',
      type: IsarType.string,
    ),
    r'seasonYear': PropertySchema(
      id: 9,
      name: r'seasonYear',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 10,
      name: r'status',
      type: IsarType.string,
    ),
    r'studio': PropertySchema(
      id: 11,
      name: r'studio',
      type: IsarType.string,
    )
  },
  estimateSize: _favoriteAnimeEstimateSize,
  serialize: _favoriteAnimeSerialize,
  deserialize: _favoriteAnimeDeserialize,
  deserializeProp: _favoriteAnimeDeserializeProp,
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
  getId: _favoriteAnimeGetId,
  getLinks: _favoriteAnimeGetLinks,
  attach: _favoriteAnimeAttach,
  version: '3.1.0+1',
);

int _favoriteAnimeEstimateSize(
  FavoriteAnime object,
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
  bytesCount += 3 + object.coverImage.length * 3;
  {
    final value = object.englishTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.romajiTitle.length * 3;
  {
    final value = object.season;
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
  {
    final value = object.studio;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _favoriteAnimeSerialize(
  FavoriteAnime object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.addedAt);
  writer.writeLong(offsets[1], object.animeId);
  writer.writeLong(offsets[2], object.averageScore);
  writer.writeString(offsets[3], object.bannerImage);
  writer.writeString(offsets[4], object.coverImage);
  writer.writeString(offsets[5], object.englishTitle);
  writer.writeLong(offsets[6], object.episodes);
  writer.writeString(offsets[7], object.romajiTitle);
  writer.writeString(offsets[8], object.season);
  writer.writeLong(offsets[9], object.seasonYear);
  writer.writeString(offsets[10], object.status);
  writer.writeString(offsets[11], object.studio);
}

FavoriteAnime _favoriteAnimeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteAnime();
  object.addedAt = reader.readDateTime(offsets[0]);
  object.animeId = reader.readLong(offsets[1]);
  object.averageScore = reader.readLongOrNull(offsets[2]);
  object.bannerImage = reader.readStringOrNull(offsets[3]);
  object.coverImage = reader.readString(offsets[4]);
  object.englishTitle = reader.readStringOrNull(offsets[5]);
  object.episodes = reader.readLongOrNull(offsets[6]);
  object.id = id;
  object.romajiTitle = reader.readString(offsets[7]);
  object.season = reader.readStringOrNull(offsets[8]);
  object.seasonYear = reader.readLongOrNull(offsets[9]);
  object.status = reader.readStringOrNull(offsets[10]);
  object.studio = reader.readStringOrNull(offsets[11]);
  return object;
}

P _favoriteAnimeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteAnimeGetId(FavoriteAnime object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteAnimeGetLinks(FavoriteAnime object) {
  return [];
}

void _favoriteAnimeAttach(
    IsarCollection<dynamic> col, Id id, FavoriteAnime object) {
  object.id = id;
}

extension FavoriteAnimeByIndex on IsarCollection<FavoriteAnime> {
  Future<FavoriteAnime?> getByAnimeId(int animeId) {
    return getByIndex(r'animeId', [animeId]);
  }

  FavoriteAnime? getByAnimeIdSync(int animeId) {
    return getByIndexSync(r'animeId', [animeId]);
  }

  Future<bool> deleteByAnimeId(int animeId) {
    return deleteByIndex(r'animeId', [animeId]);
  }

  bool deleteByAnimeIdSync(int animeId) {
    return deleteByIndexSync(r'animeId', [animeId]);
  }

  Future<List<FavoriteAnime?>> getAllByAnimeId(List<int> animeIdValues) {
    final values = animeIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'animeId', values);
  }

  List<FavoriteAnime?> getAllByAnimeIdSync(List<int> animeIdValues) {
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

  Future<Id> putByAnimeId(FavoriteAnime object) {
    return putByIndex(r'animeId', object);
  }

  Id putByAnimeIdSync(FavoriteAnime object, {bool saveLinks = true}) {
    return putByIndexSync(r'animeId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAnimeId(List<FavoriteAnime> objects) {
    return putAllByIndex(r'animeId', objects);
  }

  List<Id> putAllByAnimeIdSync(List<FavoriteAnime> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'animeId', objects, saveLinks: saveLinks);
  }
}

extension FavoriteAnimeQueryWhereSort
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QWhere> {
  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhere> anyAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'animeId'),
      );
    });
  }
}

extension FavoriteAnimeQueryWhere
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QWhereClause> {
  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> idBetween(
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> animeIdEqualTo(
      int animeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'animeId',
        value: [animeId],
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> animeIdLessThan(
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterWhereClause> animeIdBetween(
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

extension FavoriteAnimeQueryFilter
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QFilterCondition> {
  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      addedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      addedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      addedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      addedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      animeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeId',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      averageScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'averageScore',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      averageScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'averageScore',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      averageScoreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      averageScoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      averageScoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageScore',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      averageScoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      bannerImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      bannerImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bannerImage',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      bannerImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bannerImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      bannerImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bannerImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      bannerImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      bannerImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bannerImage',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      coverImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      coverImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      coverImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      coverImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverImage',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      englishTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      englishTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'englishTitle',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      englishTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'englishTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      englishTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'englishTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      englishTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      englishTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'englishTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      episodesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'episodes',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      episodesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'episodes',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      episodesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodes',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      episodesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodes',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      episodesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodes',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      episodesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      romajiTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'romajiTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      romajiTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'romajiTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      romajiTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      romajiTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'romajiTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'season',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'season',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'season',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'season',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'season',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'season',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'season',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'season',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'season',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'season',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'season',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'season',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonYearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seasonYear',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonYearIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seasonYear',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonYearEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonYear',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonYearGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonYear',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonYearLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonYear',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      seasonYearBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      studioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'studio',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      studioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'studio',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
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

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      studioContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'studio',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      studioMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'studio',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      studioIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'studio',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterFilterCondition>
      studioIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'studio',
        value: '',
      ));
    });
  }
}

extension FavoriteAnimeQueryObject
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QFilterCondition> {}

extension FavoriteAnimeQueryLinks
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QFilterCondition> {}

extension FavoriteAnimeQuerySortBy
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QSortBy> {
  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByAnimeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByAverageScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByAverageScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodes', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodes', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortBySeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortBySeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortBySeasonYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonYear', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      sortBySeasonYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonYear', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByStudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> sortByStudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.desc);
    });
  }
}

extension FavoriteAnimeQuerySortThenBy
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QSortThenBy> {
  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByAnimeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByAverageScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByAverageScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageScore', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImage', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByEnglishTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByEnglishTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodes', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByEpisodesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodes', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByRomajiTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenByRomajiTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'romajiTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenBySeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenBySeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenBySeasonYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonYear', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy>
      thenBySeasonYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seasonYear', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByStudio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.asc);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QAfterSortBy> thenByStudioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studio', Sort.desc);
    });
  }
}

extension FavoriteAnimeQueryWhereDistinct
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> {
  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedAt');
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByAnimeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeId');
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct>
      distinctByAverageScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageScore');
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByBannerImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bannerImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByCoverImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByEnglishTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'englishTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByEpisodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodes');
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByRomajiTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'romajiTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctBySeason(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'season', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctBySeasonYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasonYear');
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteAnime, FavoriteAnime, QDistinct> distinctByStudio(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'studio', caseSensitive: caseSensitive);
    });
  }
}

extension FavoriteAnimeQueryProperty
    on QueryBuilder<FavoriteAnime, FavoriteAnime, QQueryProperty> {
  QueryBuilder<FavoriteAnime, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteAnime, DateTime, QQueryOperations> addedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedAt');
    });
  }

  QueryBuilder<FavoriteAnime, int, QQueryOperations> animeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeId');
    });
  }

  QueryBuilder<FavoriteAnime, int?, QQueryOperations> averageScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageScore');
    });
  }

  QueryBuilder<FavoriteAnime, String?, QQueryOperations> bannerImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bannerImage');
    });
  }

  QueryBuilder<FavoriteAnime, String, QQueryOperations> coverImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverImage');
    });
  }

  QueryBuilder<FavoriteAnime, String?, QQueryOperations>
      englishTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'englishTitle');
    });
  }

  QueryBuilder<FavoriteAnime, int?, QQueryOperations> episodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodes');
    });
  }

  QueryBuilder<FavoriteAnime, String, QQueryOperations> romajiTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'romajiTitle');
    });
  }

  QueryBuilder<FavoriteAnime, String?, QQueryOperations> seasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'season');
    });
  }

  QueryBuilder<FavoriteAnime, int?, QQueryOperations> seasonYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonYear');
    });
  }

  QueryBuilder<FavoriteAnime, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<FavoriteAnime, String?, QQueryOperations> studioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'studio');
    });
  }
}
