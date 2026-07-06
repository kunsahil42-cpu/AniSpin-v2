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
  bytesCount += 3 + object.lastWatchedAudio.length * 3;
  bytesCount += 3 + object.lastWatchedSource.length * 3;
  bytesCount += 3 + object.romajiTitle.length * 3;
  {
    final value = object.status;
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
  bytesCount += 3 + object.genres.length * 3;
  {
    for (var i = 0; i < object.genres.length; i++) {
      final value = object.genres[i];
      bytesCount += value.length * 3;
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

extension WatchProgressQueryFilter on QueryBuilder<WatchProgress, WatchProgress, QFilterCondition> {
  QueryBuilder<WatchProgress, WatchProgress, QAfterFilterCondition> animeIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'animeId',
        value: value,
      ));
    });
  }
}

extension WatchProgressQuerySortBy on QueryBuilder<WatchProgress, WatchProgress, QSortBy> {
  QueryBuilder<WatchProgress, WatchProgress, QAfterSortBy> sortByLastWatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWatchedAt', Sort.desc);
    });
  }
}
