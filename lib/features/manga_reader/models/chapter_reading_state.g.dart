// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_reading_state.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChapterReadingStateCollection on Isar {
  IsarCollection<ChapterReadingState> get chapterReadingStates =>
      this.collection();
}

const ChapterReadingStateSchema = CollectionSchema(
  name: r'ChapterReadingState',
  id: 3251278190526806430,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.string,
    ),
    r'chapterNumber': PropertySchema(
      id: 1,
      name: r'chapterNumber',
      type: IsarType.long,
    ),
    r'isColored': PropertySchema(
      id: 2,
      name: r'isColored',
      type: IsarType.bool,
    ),
    r'lastReadPage': PropertySchema(
      id: 3,
      name: r'lastReadPage',
      type: IsarType.long,
    ),
    r'mangaId': PropertySchema(
      id: 4,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'selectedSource': PropertySchema(
      id: 5,
      name: r'selectedSource',
      type: IsarType.string,
    )
  },
  estimateSize: _chapterReadingStateEstimateSize,
  serialize: _chapterReadingStateSerialize,
  deserialize: _chapterReadingStateDeserialize,
  deserializeProp: _chapterReadingStateDeserializeProp,
  idName: r'id',
  indexes: {
    r'mangaId': IndexSchema(
      id: 7466570075891278896,
      name: r'mangaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mangaId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'chapterNumber': IndexSchema(
      id: -7659654328869413098,
      name: r'chapterNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chapterNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _chapterReadingStateGetId,
  getLinks: _chapterReadingStateGetLinks,
  attach: _chapterReadingStateAttach,
  version: '3.1.0+1',
);

int _chapterReadingStateEstimateSize(
  ChapterReadingState object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chapterId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.selectedSource.length * 3;
  return bytesCount;
}

void _chapterReadingStateSerialize(
  ChapterReadingState object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chapterId);
  writer.writeLong(offsets[1], object.chapterNumber);
  writer.writeBool(offsets[2], object.isColored);
  writer.writeLong(offsets[3], object.lastReadPage);
  writer.writeLong(offsets[4], object.mangaId);
  writer.writeString(offsets[5], object.selectedSource);
}

ChapterReadingState _chapterReadingStateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterReadingState();
  object.chapterId = reader.readStringOrNull(offsets[0]);
  object.chapterNumber = reader.readLong(offsets[1]);
  object.id = id;
  object.isColored = reader.readBool(offsets[2]);
  object.lastReadPage = reader.readLong(offsets[3]);
  object.mangaId = reader.readLong(offsets[4]);
  object.selectedSource = reader.readString(offsets[5]);
  return object;
}

P _chapterReadingStateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chapterReadingStateGetId(ChapterReadingState object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _chapterReadingStateGetLinks(
    ChapterReadingState object) {
  return [];
}

void _chapterReadingStateAttach(
    IsarCollection<dynamic> col, Id id, ChapterReadingState object) {
  object.id = id;
}

extension ChapterReadingStateQueryWhereSort
    on QueryBuilder<ChapterReadingState, ChapterReadingState, QWhere> {
  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhere>
      anyMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mangaId'),
      );
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhere>
      anyChapterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'chapterNumber'),
      );
    });
  }
}

extension ChapterReadingStateQueryWhere
    on QueryBuilder<ChapterReadingState, ChapterReadingState, QWhereClause> {
  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      mangaIdEqualTo(int mangaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mangaId',
        value: [mangaId],
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      chapterNumberEqualTo(int chapterNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chapterNumber',
        value: [chapterNumber],
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      chapterNumberNotEqualTo(int chapterNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterNumber',
              lower: [],
              upper: [chapterNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterNumber',
              lower: [chapterNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterNumber',
              lower: [chapterNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapterNumber',
              lower: [],
              upper: [chapterNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      chapterNumberGreaterThan(
    int chapterNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapterNumber',
        lower: [chapterNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      chapterNumberLessThan(
    int chapterNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapterNumber',
        lower: [],
        upper: [chapterNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterWhereClause>
      chapterNumberBetween(
    int lowerChapterNumber,
    int upperChapterNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapterNumber',
        lower: [lowerChapterNumber],
        includeLower: includeLower,
        upper: [upperChapterNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChapterReadingStateQueryFilter on QueryBuilder<ChapterReadingState,
    ChapterReadingState, QFilterCondition> {
  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chapterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chapterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chapterId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      chapterNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      isColoredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isColored',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      lastReadPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadPage',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      mangaIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
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

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedSource',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedSource',
        value: '',
      ));
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterFilterCondition>
      selectedSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedSource',
        value: '',
      ));
    });
  }
}

extension ChapterReadingStateQueryObject on QueryBuilder<ChapterReadingState,
    ChapterReadingState, QFilterCondition> {}

extension ChapterReadingStateQueryLinks on QueryBuilder<ChapterReadingState,
    ChapterReadingState, QFilterCondition> {}

extension ChapterReadingStateQuerySortBy
    on QueryBuilder<ChapterReadingState, ChapterReadingState, QSortBy> {
  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByChapterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByChapterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByIsColored() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isColored', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByIsColoredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isColored', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortBySelectedSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSource', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      sortBySelectedSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSource', Sort.desc);
    });
  }
}

extension ChapterReadingStateQuerySortThenBy
    on QueryBuilder<ChapterReadingState, ChapterReadingState, QSortThenBy> {
  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByChapterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByChapterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByIsColored() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isColored', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByIsColoredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isColored', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByLastReadPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadPage', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenBySelectedSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSource', Sort.asc);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QAfterSortBy>
      thenBySelectedSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedSource', Sort.desc);
    });
  }
}

extension ChapterReadingStateQueryWhereDistinct
    on QueryBuilder<ChapterReadingState, ChapterReadingState, QDistinct> {
  QueryBuilder<ChapterReadingState, ChapterReadingState, QDistinct>
      distinctByChapterId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QDistinct>
      distinctByChapterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterNumber');
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QDistinct>
      distinctByIsColored() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isColored');
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QDistinct>
      distinctByLastReadPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadPage');
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QDistinct>
      distinctByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId');
    });
  }

  QueryBuilder<ChapterReadingState, ChapterReadingState, QDistinct>
      distinctBySelectedSource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedSource',
          caseSensitive: caseSensitive);
    });
  }
}

extension ChapterReadingStateQueryProperty
    on QueryBuilder<ChapterReadingState, ChapterReadingState, QQueryProperty> {
  QueryBuilder<ChapterReadingState, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChapterReadingState, String?, QQueryOperations>
      chapterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterId');
    });
  }

  QueryBuilder<ChapterReadingState, int, QQueryOperations>
      chapterNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterNumber');
    });
  }

  QueryBuilder<ChapterReadingState, bool, QQueryOperations>
      isColoredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isColored');
    });
  }

  QueryBuilder<ChapterReadingState, int, QQueryOperations>
      lastReadPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadPage');
    });
  }

  QueryBuilder<ChapterReadingState, int, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<ChapterReadingState, String, QQueryOperations>
      selectedSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedSource');
    });
  }
}
