import 'package:isar/isar.dart';

part 'favorite_anime.g.dart';

@collection
class FavoriteAnime {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int animeId;

  late String romajiTitle;

  String? englishTitle;

  late String coverImage;

  String? bannerImage;

  int? averageScore;

  int? episodes;

  String? status;

  String? studio;

  String? season;

  int? seasonYear;

  DateTime addedAt = DateTime.now();
}