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
    r'author': PropertySchema(
      id: 0,
      name: r'author',
      type: IsarType.string,
    ),
    r'bannerImage': PropertySchema(
      id: 1,
      name: r'bannerImage',
      type: IsarType.string,
    ),
    r'completedChapters': PropertySchema(
      id: 2,
      name: r'completedChapters',
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
    r'lastReadAt': PropertySchema(
      id: 8,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'lastReadChapter': PropertySchema(
      id: 9,
      name: r'lastReadChapter',
      type: IsarType.long,
    ),
    r'lastReadPage': PropertySchema(
      id: 10,
      name: r'lastReadPage',
      type: IsarType.long,
    ),
    r'lastReadVolume': PropertySchema(
      id: 11,
      name: r'lastReadVolume',
      type: IsarType.long,
    ),
    r'mangaId': PropertySchema(
      id: 12,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 13,
      name: r'notes',
      type: IsarType.string,
    ),
    r'readingPercentage': PropertySchema(
      id: 14,
      name: r'readingPercentage',
      type: IsarType.double,
    ),
    r'rereadCount': PropertySchema(
      id: 15,
      name: r'rereadCount',
      type: IsarType.long,
    ),
    r'romajiTitle': PropertySchema(
      id: 16,
      name: r'romajiTitle',
      type: IsarType.string,
    ),
    r'score': PropertySchema(
      id: 17,
      name: r'score',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 18,
      name: r'status',
      type: IsarType.string,
    ),
    r'totalChapters': PropertySchema(
      id: 19,
      name: r'totalChapters',
      type: IsarType.long,
    ),
    r'totalVolumes': PropertySchema(
      id: 20,
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
  return bytesCount;
}

void _readingProgressSerialize(
  ReadingProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeString(offsets[1], object.bannerImage);
  writer.writeLongList(offsets[2], object.completedChapters);
  writer.writeString(offsets[3], object.coverImage);
  writer.writeDateTime(offsets[4], object.dateFinished);
  writer.writeDateTime(offsets[5], object.dateStarted);
  writer.writeString(offsets[6], object.englishTitle);
  writer.writeStringList(offsets[7], object.genres);
  writer.writeDateTime(offsets[8], object.lastReadAt);
  writer.writeLong(offsets[9], object.lastReadChapter);
  writer.writeLong(offsets[10], object.lastReadPage);
  writer.writeLong(offsets[11], object.lastReadVolume);
  writer.writeLong(offsets[12], object.mangaId);
  writer.writeString(offsets[13], object.notes);
  writer.writeDouble(offsets[14], object.readingPercentage);
  writer.writeLong(offsets[15], object.rereadCount);
  writer.writeString(offsets[16], object.romajiTitle);
  writer.writeLong(offsets[17], object.score);
  writer.writeString(offsets[18], object.status);
  writer.writeLong(offsets[19], object.totalChapters);
  writer.writeLong(offsets[20], object.totalVolumes);
}

ReadingProgress _readingProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingProgress();
  object.author = reader.readStringOrNull(offsets[0]);
  object.bannerImage = reader.readStringOrNull(offsets[1]);
  object.completedChapters = reader.readLongList(offsets[2]) ?? [];
  object.coverImage = reader.readString(offsets[3]);
  object.dateFinished = reader.readDateTimeOrNull(offsets[4]);
  object.dateStarted = reader.readDateTimeOrNull(offsets[5]);
  object.englishTitle = reader.readStringOrNull(offsets[6]);
  object.genres = reader.readStringList(offsets[7]) ?? [];
  object.id = id;
  object.lastReadAt = reader.readDateTime(offsets[8]);
  object.lastReadChapter = reader.readLong(offsets[9]);
  object.lastReadPage = reader.readLong(offsets[10]);
  object.lastReadVolume = reader.readLong(offsets[11]);
  object.mangaId = reader.readLong(offsets[12]);
  object.notes = reader.readStringOrNull(offsets[13]);
  object.readingPercentage = reader.readDouble(offsets[14]);
  object.rereadCount = reader.readLong(offsets[15]);
  object.romajiTitle = reader.readString(offsets[16]);
  object.score = reader.readLongOrNull(offsets[17]);
  object.status = reader.readStringOrNull(offsets[18]);
  object.totalChapters = reader.readLongOrNull(offsets[19]);
  object.totalVolumes = reader.readLongOrNull(offsets[20]);
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
      return (reader.readStringOrNull(offset)) as P;
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
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readLongOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
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

extension ReadingProgressQueryFilter on QueryBuilder<ReadingProgress, ReadingProgress, QFilterCondition> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterFilterCondition> mangaIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }
}

extension ReadingProgressQuerySortBy on QueryBuilder<ReadingProgress, ReadingProgress, QSortBy> {
  QueryBuilder<ReadingProgress, ReadingProgress, QAfterSortBy> sortByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }
}
